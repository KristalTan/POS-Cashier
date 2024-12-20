CREATE OR REPLACE PROCEDURE pr_table_delete (
	IN p_current_uid character varying(255),
	OUT p_msg text,
	INOUT p_table_id uuid,
	IN p_is_debug integer DEFAULT 0
)
LANGUAGE 'plpgsql'
AS $BODY$
-- -------------------------------------
-- init
-- -------------------------------------
DECLARE
	v_now CONSTANT timestamp = localtimestamp;
	audit_log text;
	module_code text;
	v_table_desc_old character varying(255);
BEGIN
/* 0100_0041_pr_table_delete

*/
	
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_table_delete - start';
	END IF;
	
	module_code := 'Setting - Table';
	
	-- -------------------------------------
	-- validation
	-- -------------------------------------
	IF NOT EXISTS (
		SELECT *
		FROM tb_table
		WHERE table_id = p_table_id
	) THEN
		p_msg := 'Invalid Table!!';
		RETURN;
	END IF;
		
	-- -------------------------------------
	-- process
	-- -------------------------------------
	-- Get old record for audit log purpose
	SELECT table_desc
	INTO v_table_desc_old
	FROM tb_table
	WHERE table_id = p_table_id;
	
	-- Delete record
	DELETE FROM tb_table
	WHERE table_id = p_table_id;
	
	-- Prepare Audit Log
	audit_log := 'Deleted Table: ' || v_table_name_old || '.';
	
	-- Create Audit Log
	CALL pr_sys_append_audit_log (
		p_msg => audit_log
		, p_remarks => 'pr_table_delete'
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
		RAISE NOTICE 'pr_table_delete - end';
	END IF;
	
END
$BODY$;