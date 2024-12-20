CREATE OR REPLACE PROCEDURE pr_supplier_delete (
	IN p_current_uid character varying(255),
	INOUT p_msg text,
	IN p_supplier_id uuid,
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
	v_supplier_name_old character varying(255);
BEGIN
/* 0100_0019_pr_supplier_delete

-- Delete Supplier
-- sample: 
	CALL pr_supplier_delete (
		p_current_uid => 'tester',
		p_msg => null,
		p_supplier_id => null
	);

*/

	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_supplier_delete - start';
	END IF;
	
	module_code := 'Settings - Supplier';
	
	-- -------------------------------------
	-- validation
	-- -------------------------------------
	IF NOT EXISTS (
		SELECT *
		FROM tb_supplier
		WHERE supplier_id = p_supplier_id
	) THEN 
		p_msg := 'Supplier is not exists!!'
		RETURN;
	END IF;
	
	-- -------------------------------------
	-- process
	-- -------------------------------------
	
	-- Get old reocrd for audit log purpose
	SELECT supplier_name
	INTO v_supplier_name_old
	FROM tb_supplier
	WHERE supplier_id = p_supplier_id;
	
	-- Delete the record
	DELETE FROM tb_supplier
	WHERE supplier_id = p_supplier_id;
	
	p_msg := 'ok';
	-- Prepare Audit Log
	audit_log := 'Deleted the Supplier: ' || v_supplier_name_old || '.';
	
	-- Create Audit Log
	CALL pr_sys_append_audit_log (
		p_msg => audit_log
		, p_remarks => ' pr_supplier_delete'
		, p_uid => p_current_uid
		, p_id1 => p_supplier_id
		, p_id2 => null
		, p_id3 => null
        , p_app_id => null
		, p_module_code => module_code
	);
	
	-- -------------------------------------
	-- cleanup
	-- -------------------------------------
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_supplier_delete - end';
	END IF;
	
END
$BODY$;