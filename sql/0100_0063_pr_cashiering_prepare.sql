CREATE OR REPLACE FUNCTION fn_cashiering_prepare (
	p_current_uid character varying(255),
	p_tr_date date,
	p_user_ip character varying(50), 			-- nodejs get the IP address
	p_rid integer,
	p_axn character varying(255),
	p_url character varying(255),
	p_is_debug integer DEFAULT 0
) RETURNS TABLE (
	msg text,
	pymt_type_desc character varying(255),
	pymt_mode_desc character varying(255),
	amt numeric(15, 4),
	count_t integer 
)
LANGUAGE 'plpgsql'
AS $BODY$
-- -------------------------------------
-- init
-- -------------------------------------
DECLARE
	local_tx BOOLEAN := FALSE;
    err_msg TEXT;
    severity INT;
    state INT;
	v_pos_station_id character varying(50);
	v_now CONSTANT timestamp = current_timestamp;
	v_cashiering_id uuid;
	v_start_on timestamp;
	v_msg text;
	audit_log text;
	module_code text;
BEGIN
/* 0100_0063_pr_cashiering_prepare

	SELECT * 
	FROM fn_cashiering_prepare (
		p_current_uid => 'tester',
		p_tr_date => '2024-11-25',
		p_user_ip => '127.0.0.1', 			
		p_rid => null,
		p_axn => null,
		p_url => null
	);

*/

	-- -------------------------------------
	-- validation
	-- -------------------------------------
	IF LENGTH(COALESCE(p_current_uid, '')) = 0 THEN
		RETURN QUERY (
			SELECT 
				'Cashier ID cannot be blank!!'::text, null::character varying AS pymt_type_desc, null::character varying AS pymt_mode_desc, 
				null::numeric AS amt, null::integer AS count_
		);
	END IF;
	
	IF p_tr_date IS NULL THEN
		p_tr_date := fn_get_current_trans_dt();
	END IF;
	
	IF LENGTH(COALESCE(p_user_ip, '')) = 0 THEN
		RETURN QUERY (
			SELECT 
				'POS IP Address cannot be blank!!'::text, null::character varying AS pymt_type_desc, null::character varying AS pymt_mode_desc, 
				null::numeric AS amt, null::integer AS count_
		);
	END IF;
	
	SELECT pos_station_id
	INTO v_pos_station_id
	FROM tb_pos_station
	WHERE ip = p_user_ip;
	
	IF v_pos_station_id IS NULL THEN
		v_pos_station_id = '???';
	END IF;
	
	IF NOT EXISTS (
		SELECT cashiering_id
		FROM tb_cashiering
		WHERE 
			tr_date = p_tr_date
			AND cashier_id = p_current_uid
			AND start_on IS NOT NULL
	) THEN
		RETURN QUERY (
			SELECT 
				'The cashiering shift has not been started!!'::text, null::character varying AS pymt_type_desc, null::character varying AS pymt_mode_desc, 
				null::numeric AS amt, null::integer AS count_
		);
	END IF;
	
	SELECT cashiering_id, start_on
	INTO v_cashiering_id, v_start_on
	FROM tb_cashiering
	WHERE 
		tr_date = p_tr_date
		AND cashier_id = p_current_uid
		AND start_on IS NOT NULL
		AND end_on IS NULL;		

	-- -------------------------------------
	-- process
	-- -------------------------------------
    -- Delete old data
    DELETE FROM tb_cashiering_details
    WHERE cashiering_id = v_cashiering_id;

    -- Insert new data
    INSERT INTO tb_cashiering_details (
    	cashiering_detail_id, tr_date, pos_station_id, cashiering_id, pymt_type_id, pymt_type_desc, pymt_mode_desc, amt, count
    )
    SELECT
        gen_random_uuid(),  ot.tr_date, v_pos_station_id, v_cashiering_id, p.pymt_type_id, 
		p.pymt_type_desc, p.pymt_mode_desc, 	SUM(COALESCE(il.amt, 0)), COUNT(*)
    FROM tb_order_trans ot
    INNER JOIN tb_order_trans_item_line il ON ot.order_trans_id = il.order_trans_id
    INNER JOIN vw_pymt_mode p ON p.pymt_mode_id = il.pymt_mode_id
    WHERE 
		ot.tr_type = 'C'  
        AND il.tr_date = p_tr_date
        AND il.created_by = p_current_uid
        AND il.created_on BETWEEN v_start_on AND v_now
    GROUP BY ot.tr_date, p.pymt_type_id, p.pymt_type_desc, p.pymt_mode_desc;

    -- Update the total amount
    UPDATE tb_cashiering
    SET 
		modified_on = v_now,
        modified_by = p_current_uid,
        total_collection_amt = (
        	SELECT SUM(COALESCE(d.amt, 0))
            FROM tb_cashiering_details d
            WHERE d.cashiering_id = v_cashiering_id
        )
    WHERE 
		tr_date = p_tr_date
		AND cashier_id = p_current_uid
		AND start_on IS NOT NULL
		AND end_on IS NULL;
	
	v_msg := 'ok';
	module_code := 'Cashiering - Prepare (close)';
	audit_log := 'Calculate total collecltion of cashiering shift: ' || 
					'Transaction Date: ' || p_tr_date::text || ', ' ||
					'Cashier ID: ' || p_current_uid::text || ', '
					'POS IP: ' || p_user_ip::text || ', ' ||
					'POS Station ID: ' || v_pos_station_id || '.' ;
	
	-- Return result
	RETURN QUERY (
		SELECT 
			null::text AS msg, a.pymt_type_desc, a.pymt_mode_desc, a.amt, a.count AS count_
		FROM tb_cashiering_details a
		WHERE a.cashiering_id = v_cashiering_id
		ORDER BY
			a.pymt_type_desc, a.pymt_mode_desc
	);

	-- Create Audit Log
	CALL pr_sys_append_audit_log (
		p_msg => audit_log
		, p_remarks => 'fn_cashiering_prepare'
		, p_uid => p_current_uid
		, p_id1 => v_cashiering_id
		, p_id2 => null
		, p_id3 => null
        , p_app_id => null
		, p_module_code => module_code
	); 
	
	-- -------------------------------------
	-- cleanup
	-- -------------------------------------

END
$BODY$;