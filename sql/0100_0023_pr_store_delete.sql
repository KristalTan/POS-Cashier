CREATE OR REPLACE PROCEDURE pr_store_delete (
	IN p_current_id character varying(255),
	OUT p_msg text,
	IN p_store_id uuid,
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
	v_store_name_old character varying(255);
BEGIN
/* 0100_0023_pr_store_delete


*/

	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_store_delete - start';
	END IF;
	
	module_code := 'Settings - Store';
	
	-- -------------------------------------
	-- validation
	-- -------------------------------------
	IF NOT EXISTS (
		SELECT *
		FROM tb_store
		WHERE store_id = p_store_id
	) THEN 
		p_msg := 'Store Name is not exists!!';
		RETURN;
	END IF;
	
	-- -------------------------------------
	-- process
	-- -------------------------------------
	
	-- Get old record for aaudit log purpose
	SELECT store_name
	INTO v_store_name_old
	FROM tb_store
	WHERE store_id = p_store_id;
	
	-- Delete the record
	DELETE FROM tb_store
	WHERE store_id = p_store_id;
	
	-- Prepare Audit Log
	audit_log := 'Deleted Store Name: ' || v_store_name_old || '.';
	
	-- Create Audit Log
	CALL pr_sys_append_audit_log (
		p_msg => audit_log
		, p_remarks => 'pr_store_delete'
		, p_uid => p_current_uid
		, p_id1 => p_store_id
		, p_id2 => null
		, p_id3 => null
        , p_app_id => null
		, p_module_code => module_code
	);
	
	-- -------------------------------------
	-- cleanup
	-- -------------------------------------
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_store_delete - end';
	END IF;

END
$BODY$;