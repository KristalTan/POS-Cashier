CREATE OR REPLACE PROCEDURE pr_cashiering_start (
	IN p_current_uid character varying(255),
	OUT p_msg text,
	IN p_tr_date date,
	IN p_user_ip character varying(50), 			-- nodejs get the IP address
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
	p_cashiering_id uuid;
BEGIN
/* 0100_0060_pr_cashiering_start

	CALL pr_cashiering_start (
		p_current_uid => 'tester',
		p_msg => null,
		p_tr_date => '20241122',
		p_user_ip => '127.0.0.1', 			
		p_rid => null,
		p_axn => null,
		p_url => null
	);

*/

	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_cashiering_start - start';
	END IF;
	
	module_code := 'Cashiering - Start Cashiering';

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
	
	IF EXISTS (
		SELECT cashiering_id
		FROM tb_cashiering
		WHERE 
			tr_date = p_tr_date
			AND cashier_id = p_current_uid
			AND end_on IS NULL 
	) THEN
		p_msg := 'The cashiering shift already been started!!';
		RETURN;
	END IF;
	
	-- IP check

	-- -------------------------------------
	-- process
	-- -------------------------------------
	p_cashiering_id := gen_random_uuid();
	
	INSERT INTO tb_cashiering (
		cashiering_id, created_on, created_by, modified_on, modified_by, tr_date, pos_station_ip, cashier_id, ip, start_on
	) VALUES (
		p_cashiering_id, v_now, p_current_uid, v_now, p_current_uid, p_tr_date, v_pos_station_id, p_current_uid, p_user_ip, v_now
	);
	
	audit_log := 'Start Cashiering Shirt on ' || v_now::text || 
					', Date: ' || p_tr_date::text || 
					', Pos Station: ' || v_pos_station_id::text || 
					', Cashier ID: ' || p_current_uid::text || '.';
	
	p_msg := 'ok';
	
	-- Create Audit Log
	CALL pr_sys_append_audit_log (
		p_msg => audit_log
		, p_remarks => 'pr_cashiering_start'
		, p_uid => p_current_uid
		, p_id1 => p_cashiering_id
		, p_id2 => null
		, p_id3 => null
        , p_app_id => null
		, p_module_code => module_code
	); 

	-- -------------------------------------
	-- cleanup
	-- -------------------------------------
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_cashiering_start - end';
	END IF;

END
$BODY$;