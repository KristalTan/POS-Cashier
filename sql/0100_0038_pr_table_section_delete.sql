CREATE OR REPLACE PROCEDURE pr_table_section_delete (
	IN p_current_uid character varying(255),
	OUT p_msg text,
	INOUT p_table_section_id uuid,
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
	v_table_section_name_old character varying(255);
BEGIN
/* 0100_0038_pr_table_section_delete

*/
	
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_table_section_delete - start';
	END IF;
	
	module_code := 'Setting - Table Section';
	
	-- -------------------------------------
	-- validation
	-- -------------------------------------
	IF NOT EXISTS (
		SELECT *
		FROM tb_table_section
		WHERE table_section_id = p_table_section_id
	) THEN
		p_msg := 'Invalid Table Section!!';
		RETURN;
	END IF;
	
	IF EXISTS (
		SELECT *
		FROM tb_table
		WHERE table_section_id = p_table_section_id
	) THEN
		p_msg := 'Deletion is not allowed because this record is in use in Table Module!!';
		RETURN;
	END IF;
	
	-- -------------------------------------
	-- process
	-- -------------------------------------
	-- Get old record for audit log purpose
	SELECT table_section_name
	INTO v_table_section_name_old
	FROM tb_table_section
	WHERE table_section_id = p_table_section_id;
	
	-- Delete record
	DELETE FROM tb_table_section
	WHERE table_section_id = p_table_section_id;
	
	-- Prepare Audit Log
	audit_log := 'Deleted Table Section: ' || v_table_section_name_old || '.';
	
	-- Create Audit Log
	CALL pr_sys_append_audit_log (
		p_msg => audit_log
		, p_remarks => 'pr_table_section_delete'
		, p_uid => p_current_uid
		, p_id1 => p_table_section_id
		, p_id2 => null
		, p_id3 => null
        , p_app_id => null
		, p_module_code => module_code
	);
	
	-- -------------------------------------
	-- cleanup
	-- -------------------------------------
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_table_section_delete - end';
	END IF;
	
END
$BODY$;