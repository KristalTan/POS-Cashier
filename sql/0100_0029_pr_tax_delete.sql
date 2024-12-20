CREATE OR REPLACE PROCEDURE pr_tax_delete (
	IN p_current_uid character varying(255),
	OUT p_msg text,
	IN p_tax_id uuid,
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
	v_tax_code_old character varying(255);
BEGIN
/* 0100_0029_pr_tax_delete

*/
	
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_tax_delete - start';
	END IF;
	
	module_code := 'Settings - Tax';
	
	-- -------------------------------------
	-- validation
	-- -------------------------------------
	IF NOT EXISTS (
		SELECT *
		FROM tb_tax
		WHERE tax_id = p_tax_id
	) THEN
		p_msg := 'Tax is not exists!!'
		RETURN;
	END IF;
	
	-- -------------------------------------
	-- process
	-- -------------------------------------
	
	-- Get old record for audit log purpose
	SELECT tax_code
	INTO v_tax_code_old 
	FROM tb_tax
	WHERE tax_id = p_tax_id;
	
	-- Delete record
	DELETE FROM tb_tax	
	WHERE tax_id = p_tax_id;
	
	p_msg := 'ok';
	
	-- Prepare Audit Log
	audit_log := 'Deleted Tax: ' || v_tax_code_old || '.';
	
	-- Create Audit Log
	CALL pr_sys_append_audit_log (
		p_msg => audit_log
		, p_remarks => 'pr_tax_delete'
		, p_uid => p_current_uid
		, p_id1 => p_tax_id
		, p_id2 => null
		, p_id3 => null
        , p_app_id => null
		, p_module_code => module_code
	);
	
	-- -------------------------------------
	-- cleanup
	-- -------------------------------------
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_tax_delete - end';
	END IF;
	
END
$BODY$;