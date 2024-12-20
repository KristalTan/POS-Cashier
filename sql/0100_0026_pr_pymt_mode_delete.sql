CREATE OR REPLACE PROCEDURE pr_pymt_mode_delete (
	IN p_current_uid character varying(255),
	OUT p_msg text,
	IN p_pymt_mode_id uuid,
	IN p_is_debug integer DEFAULT 0
)
LANGUAGE 'plpgsql'
AS $BODY$
-- -------------------------------------
-- init
-- -------------------------------------
DECLARE
	audit_log text;
	module_code text;
	v_pymt_mode_desc_old character varying(255);
BEGIN
/* 0100_0026_pr_pymt_mode_delete


*/

	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_pymt_mode_delete - start';
	END IF;
	
	module_code := 'Settings - Payment Mode';
	
	-- -------------------------------------
	-- validation
	-- -------------------------------------
	IF NOT EXISTS (
		SELECT *
		FROM tb_pymt_mode
		WHERE pymt_mode_id = p_pymt_mode_id
	) THEN
		p_msg := 'Payment Mode is not exists!!';
		RETURN;
	END IF;
	
	IF EXISTS (
		SELECT *
		FROM tb_order_item_line_trans
		WHERE pymt_mode_id = p_pymt_mode_id
	) THEN
		p_msg := 'Deletetion is not allowed because the record is in used in Sales Transaction!!';
		RETURN;
	END IF;
	
	-- -------------------------------------
	-- process
	-- -------------------------------------
	
	-- Get old record for audit log purpose
	SELECT pymt_mode_desc
	INTO v_pymt_mode_desc_old
	FROM tb_pymt_mode
	WHERE pymt_mode_id = p_pymt_mode_id;
	
	-- Delete Record
	DELETE FROM tb_pymt_mode 
	WHERE pymt_mode_id = p_pymt_mode_id;
	
	p_msg := 'ok';
	
	-- Prepare Audit Log
	audit_log := 'Deleted Payment Mode: ' || v_pymt_mode_desc_old || '.';
	
	-- Create Audit Log
	CALL pr_sys_append_audit_log (
		p_msg => audit_log
		, p_remarks => 'pr_pymt_mode_delete'
		, p_uid => p_current_uid
		, p_id1 => p_pymt_mode_id
		, p_id2 => null
		, p_id3 => null
        , p_app_id => null
		, p_module_code => module_code
	);
	
	-- -------------------------------------
	-- cleanup
	-- -------------------------------------
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_pymt_mode_delete - end';
	END IF;
	
END
$BODY$;