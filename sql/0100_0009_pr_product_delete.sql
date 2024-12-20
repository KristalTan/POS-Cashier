CREATE OR REPLACE PROCEDURE pr_product_delete (
	IN p_current_uid character varying(255), 
	OUT p_msg text,
	INOUT p_product_id uuid,
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
	v_product_desc_old varchar(255);
BEGIN
/* 0100_0009_pr_product_delete

*/

	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_product_delete - start';
	END IF;
	
	module_code := 'Settings - Product';
	
	-- -------------------------------------
	-- validation
	-- -------------------------------------	
	IF NOT EXISTS (
		SELECT *
		FROM tb_product
		WHERE product_id = p_product_id 
	) THEN
		p_msg := 'The Record is not exists!!';
		RETURN;
	END IF;
	
	IF EXISTS (
		SELECT *
		FROM tb_order_item_line_trans
		WHERE product_id = p_product_id
	) THEN
		p_msg := 'Deletetion is not allowed because the record is in used in Sales Transaction!!';
		RETURN;
	END IF;
	
	-- -------------------------------------
	-- process
	-- -------------------------------------
	SELECT product_desc
	INTO v_product_desc_old
	FROM tb_product
	WHERE product_id = p_product_id;
	
	-- Delete the record
	DELETE FROM tb_product
	WHERE product_id = p_product_id;
	
	DELETE FROM tb_modifier_group
	WHERE product_id = p_product_id;
	
	-- Prepare the Audit Log
	audit_log := 'Deleted Product: ' || v_product_desc_old;
	p_msg := 'ok';
	
	-- Create Audit Log
	CALL pr_sys_append_audit_log (
		p_msg => audit_log
		, p_remarks => 'pr_product_delete'
		, p_uid => p_current_uid
		, p_id1 => p_product_id
		, p_id2 => null
		, p_id3 => null
        , p_app_id => null
		, p_module_code => module_code
	);
	
	-- -------------------------------------
	-- cleanup
	-- -------------------------------------
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_product_delete - end';
	END IF;

END
$BODY$;