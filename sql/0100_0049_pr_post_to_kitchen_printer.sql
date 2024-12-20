CREATE OR REPLACE PROCEDURE pr_pos_to_kitchen_printer (
	IN p_current_uid character varying(255),
	OUT p_msg text,
	IN p_order_trans_id uuid,
	IN p_is_debug integer DEFAULT 0
)
LANGUAGE 'plpgsql'
AS $BODY$
-- -------------------------------------
-- init
-- -------------------------------------
DECLARE
	module_code text;
BEGIN
/*

*/

	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_pos_to_kitchen_printer - start';
	END IF;
	
	module_code := 'Order - Post to Kitchen';

	-- -------------------------------------
	-- validation
	-- -------------------------------------

	-- -------------------------------------
	-- process
	-- -------------------------------------
	SELECT *
	FROM tb_stock_trans st 
	INNER JOIN tb_product p ON p.product_id = st.product_id
	WHERE st.order_trans_id = p_order_trans_id;

	-- -------------------------------------
	-- cleanup
	-- -------------------------------------
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_pos_to_kitchen_printer - end';
	END IF;

END
$BODY$;