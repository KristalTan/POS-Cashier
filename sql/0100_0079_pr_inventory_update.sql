CREATE OR REPLACE PROCEDURE pr_inventory_update (
	IN p_current_uid character varying(255),
	OUT p_msg text,
	IN p_product_id uuid,
	IN p_qty integer,
	IN p_reorder_qty integer,
	IN p_rid integer,
	IN p_axn character varying(255),
	IN p_url character varying(255),
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
BEGIN
/* 0100_0079_pr_inventory_update

*/

	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_inventory_update - start';
	END IF;
	
	module_code := 'Inventory';

	-- -------------------------------------
	-- validation
	-- -------------------------------------
	IF fn_to_guid(p_product_id) = fn_empty_guid() THEN
		p_msg := 'Invalid Product!!';
		RETURN;
	END IF;
	
	IF NOT EXISTS (
		SELECT product_id
		FROM tb_product
		WHERE 
			product_id = p_product_id
			AND is_enable_track_stock = 1
	) THEN
		p_msg := 'Product not found!!';
	END IF;

	-- -------------------------------------
	-- process
	-- -------------------------------------
	SELECT qty, reorder_level
	INTO v_qty_old, v_reorder_level_old
	FROM tb_inventory
	WHERE product_id = p_product_id;
	
	IF p_axn = 'si' THEN
		
		-- Update stock in qty value
		UPDATE tb_inventory
		SET qty = COALESCE(v_qty_old, 0) + p_qty
		WHERE product_id = p_product_id;
		
		audit_log := 'Stock In - ' || 
						'Product: ' || p_product_id::text ||
						'Qty: ' || p_qty::text || '.';
	
	ELSIF p_axn = 'sadj' THEN
		
		-- Update stock adjustment qty value
		UPDATE tb_inventory
		SET qty = p_qty
		WHERE product_id = p_product_id;
		
		audit_log := 'Stock Adjustment - ' || 
						'Product: ' || p_product_id::text ||
						'Qty from ' || v_qty_old::text || ' to ' || p_qty || '.';
	
	ELSE 
	
		-- Update reorder level
		UPDATE tb_inventory
		SET reorder_level = p_reorder_qty
		WHERE product_id = p_product_id;
		
		audit_log := 'Updated Stock Reorder Level from ' || v_reorder_level_old || ' to ' || p_reorder_qty::text || '.';
	
	END IF;
	
	p_msg := 'ok';
	
	-- Create Audit Log
	CALL pr_sys_append_audit_log (
		p_msg => audit_log
		, p_remarks => 'pr_inventory_update'
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
		RAISE NOTICE 'pr_inventory_update - end';
	END IF;

END
$BODY$;