CREATE OR REPLACE PROCEDURE pr_inventory_init (
	IN p_current_uid character varying(255),
	OUT p_msg text,
	IN p_product_id uuid,
-- 	IN p_qty integer,
-- 	IN p_reorder_qty integer,
-- 	IN p_supplier_id uuid,
-- 	IN p_sku_code character varying(50),
-- 	IN p_category_id uuid,
	IN p_is_debug integer DEFAULT 0
)
LANGUAGE 'plpgsql'
AS $BODY$
-- -------------------------------------
-- init
-- -------------------------------------
DECLARE
	v_now CONSTANT timestamp = current_timestamp;
	module_code text;
	audit_log text;
	v_qty_old integer;
	v_reorder_level_old integer;
	v_supplier_id_old uuid;
	v_sku_code_old character varying(50);
	v_category_id_old uuid;
	p_supplier_id uuid; 
	p_sku_code character varying(50);
	p_category_id uuid;
BEGIN
/*

*/

	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_inventory_init - start';
	END IF;
	
	module_code := 'Inventory - Initail';

	-- -------------------------------------
	-- validation
	-- -------------------------------------
	IF fn_to_guid(p_product_id) = fn_empty_guid() THEN
		p_msg := 'Product cannot be blank!!';
		RETURN;
	END IF;
	
	IF NOT EXISTS (
		SELECT product_id
		FROM tb_product
		WHERE 
			product_id = p_product_id
			AND inventory_type_id = '6b24a5e7-e060-43b4-a2fb-555817e510e0'
			AND is_enable_track_stock = 1
	) THEN
		p_msg := 'Invalid Product!!';
		RETURN;
	END IF;
	
	-- -------------------------------------
	-- progress
	-- -------------------------------------
	
	IF NOT EXISTS (
		SELECT product_id
		FROM tb_inventory
		WHERE product_id = p_product_id
	) THEN
	
		INSERT INTO tb_inventory (
			created_on, created_by, modified_on, modified_by, product_id, qty, reorder_level, supplier_id, sku_code, date_added, last_updated, category_id
		)
		SELECT
			v_now, p_current_uid, v_now, p_current_uid, p_product_id, 0, 0, supplier_id, sku_code, created_on, modified_on, category_id
		FROM tb_product
		WHERE 
			product_id = p_product_id
			AND inventory_type_id = '6b24a5e7-e060-43b4-a2fb-555817e510e0'
			AND is_enable_track_stock = 1;
			
		audit_log := 'Initail Inventory - ' || 
						'Product: ' || p_product_id || '.';
			
	ELSE
		
		SELECT qty, reorder_level, supplier_id, sku_code, category_id
		INTO v_qty_old, v_reorder_level_old, v_supplier_id_old, v_sku_code_old, v_category_id_old
		FROM tb_inventory
		WHERE product_id = p_product_id;
		
		SELECT supplier_id, sku_code, category_id
		INTO p_supplier_id, p_sku_code, p_category_id
		FROM tb_product
		WHERE product_id = p_product_id;
		
		UPDATE tb_inventory
		SET
			modified_on = v_now,
			modified_by = p_current_uid,
			qty = v_qty_old,
			reorder_level = v_reorder_level_old,
			supplier_id = COALESCE(p_supplier_id, v_supplier_id_old),
			sku_code = COALESCE(p_sku_code, v_sku_code_old),
			category_id = COALESCE(p_category_id, v_category_id_old)
		WHERE product_id = p_product_id;
		
		audit_log := 'Updated Inventory - ' ||
						'Product: ' || p_product_id || ', ' ||
						'Supplier From ' || v_supplier_id_old || ' to ' || p_supplier_id || ', ' ||
						'SKU Code From ' || v_sku_code_old || ' to ' || p_sku_code_id || ', ' ||
						'Category From ' || v_category_id_old || ' to ' || p_category_id || '.';
		
	END IF;
	
	p_msg := 'ok';
	
	-- Create Audit Log
	CALL pr_sys_append_audit_log (
		p_msg => audit_log
		, p_remarks => 'pr_inventory_init'
		, p_uid => p_product_id
		, p_id1 => null
		, p_id2 => null
		, p_id3 => null
        , p_app_id => null
		, p_module_code => module_code
	); 

	-- -------------------------------------
	-- cleanup
	-- -------------------------------------
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_inventory_init - end';
	END IF;

END
$BODY$;