CREATE OR REPLACE PROCEDURE pr_prod_category_delete (
	IN p_current_uid character varying(255),
	OUT p_msg text,
	IN p_category_id uuid,
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
	v_category_desc_old character varying(255);
BEGIN
/* 0100_0003_pr_prod_category_delete

*/

	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_prod_catgeory_delete - start';
	END IF;
	
	module_code := 'Product Category';
	
	-- -------------------------------------
	-- validation
	-- -------------------------------------
	IF NOT EXISTS (
		SELECT *
		FROM tb_prod_category
		WHERE category_id = p_category_id
	) THEN
		p_msg := 'Category is not exists!!';
		RETURN;
	END IF;
	
	IF EXISTS (
		SELECT * 
		FROM tb_product
		WHERE category_id = p_category_id
	) THEN 
		p_msg := 'Deletion is not allowed because the record in use in Product!!';
		RETURN;
	END IF;
	
	-- -------------------------------------
	-- process
	-- -------------------------------------
	
	-- Get old record for audit log purpose
	SELECT category_desc
	INTO v_category_desc_old
	FROM tb_prod_category
	WHERE category_id = p_category_id;
	
	-- Delete the record
	DELETE FROM tb_prod_category
	WHERE category_id = p_category_id;
	
	-- Prepare Audit Log
	audit_log := 'Deleted Category: ' || v_category_desc_old || '.';
	
	p_msg := 'ok';
	
	-- Create Audit Log
	CALL pr_sys_append_audit_log (
		p_msg => audit_log
		, p_remarks => 'pr_prod_category_delete'
		, p_uid => p_current_uid
		, p_id1 => p_category_id
		, p_id2 => null
		, p_id3 => null
        , p_app_id => null
		, p_module_code => module_code
	);
	
	-- -------------------------------------
	-- cleanup
	-- -------------------------------------
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_prod_catgeory_delete - end';
	END IF;

END
$BODY$;