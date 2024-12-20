CREATE OR REPLACE PROCEDURE pr_receipt_temp_delete (
	IN p_current_uid character varying(255),
	OUT p_msg text,
	IN p_receipt_temp_id uuid,
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
	v_receipt_temp_name_old character varying(255);
BEGIN 
/* 0100_0032_pr_receipt_temp_delete

*/

	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_receipt_temp_delete - start';
	END IF;
	
	module_code := 'Settings - Receipt Template';
	
	-- -------------------------------------
	-- validation
	-- -------------------------------------
	IF NOT EXISTS (
	 	SELECT *
		FROM tb_receipt_temp
		WHERE receipt_temp_id = p_receipt_temp_id
	) THEN
		p_msg := 'Receipt Template is not exists!!';
		RETURN;
	END IF;
	
	IF EXISTS (
		SELECT *
		FROM tb_store
		WHERE receipt_temp_id = p_receipt_temp_id
	) THEN
		p_msg := 'Deletion is not allowed because the record is in used in store!!';
		RETURN;
	END IF;
	
	-- -------------------------------------
	-- process
	-- -------------------------------------
	
	-- Get old record for audit log purpose
	SELECT receipt_temp_name
	INTO v_receipt_temp_name_old
	FROM tb_receipt_temp
	WHERE receipt_temp_id = p_receipt_temp_id;
	
	-- Delete record
	DELETE FROM tb_receipt_temp
	WHERE receipt_temp_id = p_receipt_temp_id;
	
	-- Prepare Audit Log
	audit_log := 'Deleted Receipt Template: ' || v_receipt_temp_name_old || '.';
	
	p_msg := 'ok';
	
	-- Create Audit Log
	CALL pr_sys_append_audit_log (
		p_msg => audit_log
		, p_remarks => 'pr_receipt_temp_delete'
		, p_uid => p_current_uid
		, p_id1 => p_receipt_temp_id
		, p_id2 => null
		, p_id3 => null
        , p_app_id => null
		, p_module_code => module_code
	);
	
	-- -------------------------------------
	-- cleanup
	-- -------------------------------------
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_receipt_temp_delete - end';
	END IF;

END
$BODY$;