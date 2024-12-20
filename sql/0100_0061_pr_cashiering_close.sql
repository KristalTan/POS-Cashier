CREATE OR REPLACE PROCEDURE pr_cashiering_close (
	IN p_current_uid character varying(255),
	OUT p_msg text,
	IN p_tr_date date,
	IN p_user_ip character varying(50), 			-- nodejs get the IP address
	IN p_remarks text,
	IN p_total_collection numeric(15, 4),
	IN p_rid integer,
	IN p_axn character varying(255),
	IN p_url character varying(255),
	IN p_is_debug integer DEFAULT 0
) 
LANGUAGE 'plpgsql'
AS $BODY$
-- -------------------------------------
-- init
-- -------------------------------------
DECLARE
	v_now CONSTANT timestamp = current_timestamp;
	audit_log text;
	module_code text;
	v_pos_station_id character varying(50);
	v_cashiering_id uuid;
BEGIN
/* 0100_0061_pr_cashiering_close

	CALL pr_cashiering_close (
		p_current_uid => 'tester',
		p_msg => null,
		p_tr_date => '2024-11-22',
		p_user_ip => '127.0.0.1',
		p_remarks => null,
		p_total_collection => null,
		p_rid => null,
		p_axn => null,
		p_url => null
	);

*/

	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_cashiering_close - start';
	END IF;
	
	module_code := 'Cashiering - Close Cashiering';


	-- -------------------------------------
	-- validation
	-- -------------------------------------
	IF LENGTH(COALESCE(p_current_uid, '')) = 0 THEN
		p_msg := 'Cashier ID cannot be blank!!';
		RETURN;
	END IF;
	
	IF LENGTH(COALESCE(p_user_ip, '')) = 0 THEN
		p_msg := 'POS IP Address cannot be blank!!';
		RETURN;
	END IF;
	
	SELECT pos_station_id
	INTO v_pos_station_id
	FROM tb_pos_station
	WHERE ip = p_user_ip;
	
	IF v_pos_station_id IS NULL THEN
		v_pos_station_id = '???';
	END IF;
	
	IF p_tr_date IS NULL THEN 
		p_tr_date := fn_get_current_trans_dt();
	END IF;
	
	IF NOT EXISTS (
		SELECT cashiering_id
		FROM tb_cashiering
		WHERE 
			tr_date = p_tr_date
			AND cashier_id = p_current_uid
			AND start_on IS NOT NULL
			AND end_on IS NULL 
	) THEN
		p_msg := 'The cashiering shift has not been started!!';
		RETURN;
	END IF;
	
	-- IP check
	
	-- -------------------------------------
	-- process
	-- -------------------------------------
	SELECT cashiering_id
	INTO v_cashiering_id
	FROM tb_cashiering
	WHERE 
		tr_date = p_tr_date
		AND cashier_id = p_current_uid
		AND start_on IS NOT NULL
		AND end_on IS NULL;
	
	UPDATE tb_cashiering
	SET
		end_on = v_now,
		remarks = p_remarks,
		total_collection_amt = p_total_collection,
		modified_on = v_now,
		modified_by = p_current_uid
	WHERE
		tr_date = p_tr_date
		AND cashier_id = p_current_uid
		AND start_on IS NOT NULL
		AND end_on IS NULL;
		
	audit_log := 'Close Cashiering on: ' || v_now::text ||
					', Date: ' || p_tr_date::text || 
					', Pos Station: ' || v_pos_station_id::text || 
					', Cashier ID: ' || p_current_uid::text || 
					', Total Collection: ' || p_total_collection::text || '.';
		
	p_msg := 'ok';
	
	-- Create Audit Log
	CALL pr_sys_append_audit_log (
		p_msg => audit_log
		, p_remarks => 'pr_cashiering_close'
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
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_cashiering_close - end';
	END IF;

END
$BODY$;