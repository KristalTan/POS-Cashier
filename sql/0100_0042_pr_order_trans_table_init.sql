CREATE OR REPLACE PROCEDURE pr_order_trans_table_init (
	IN p_current_uid character varying(255),
	OUT p_msg text,
	IN p_table_id uuid,
	IN p_table_desc character varying(255),
	IN p_is_debug integer DEFAULT 0
)
LANGUAGE 'plpgsql'
AS $BODY$
-- -------------------------------------
-- init
-- -------------------------------------
DECLARE
	v_now CONSTANT timestamp = localtimestamp;
	p_order_trans_table_id uuid;
	v_table_desc_old character varying(255);
	audit_log text;
	module_code text;
BEGIN
/*

*/
	
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_order_trans_table_init - start';
	END IF;
	
	module_code := 'Order - Table Status';

	-- -------------------------------------
	-- validation
	-- -------------------------------------
	IF NOT EXISTS (
		SELECT table_id
		FROM tb_table
		WHERE table_id = p_table_id
	) THEN
		p_msg := 'Invalid Table!!';
		RETURN;
	END IF;
	
	-- -------------------------------------
	-- process
	-- -------------------------------------
	IF NOT EXISTS (
		SELECT table_id 
		FROM tb_order_trans_table 
		WHERE table_id = p_table_id
	) THEN 
	
		p_order_trans_table_id := gen_random_uuid();
		
		INSERT INTO tb_order_trans_table (
			order_trans_table_id, created_on, created_by, modified_on, modified_by, table_id, table_desc, is_occ
		) VALUES (
			p_order_trans_table_id, v_now, p_current_uid, v_now, p_current_uid, p_table_id, p_table_desc, 0
		);
		
		audit_log := 'Setup Table Status Successfully, Table No: ' || p_table_desc || '.';
		
	ELSE 
	
		SELECT table_desc
		INTO v_table_desc_old
		FROM tb_order_trans_table
		WHERE table_id = p_table_id;
		
		UPDATE tb_order_trans_table 
		SET table_desc = p_table_desc
		WHERE table_id = p_table_id;
		
		audit_log := 'Updated Table Status Successfully, Table No: ' || p_table_desc || '.';
		
	END IF;
	
	p_msg := 'ok';
	
	-- Create Audit Log
	CALL pr_sys_append_audit_log (
		p_msg => audit_log
		, p_remarks => 'pr_order_trans_table_init'
		, p_uid => p_current_uid
		, p_id1 => p_table_id
		, p_id2 => null
		, p_id3 => null
        , p_app_id => null
		, p_module_code => module_code
	);
	
	-- -------------------------------------
	-- cleanup
	-- -------------------------------------
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_order_trans_table_init - end';
	END IF;

END
$BODY$;