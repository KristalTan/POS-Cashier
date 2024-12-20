CREATE OR REPLACE FUNCTION fn_order_product_list (
	p_current_uid character varying(255),
	p_rid integer,
	p_axn character varying(255),
	p_url character varying(255),
	p_is_debug integer DEFAULT 0
) RETURNS TABLE (
	product_id uuid,
	product_desc character varying(255),
	product_code character varying(50),
	category_id uuid, 
	category_desc character varying(255),
	product_tag character varying(255),
	product_img_path character varying(255),
	cost numeric(15, 4),
	avail integer
)
LANGUAGE 'plpgsql'
AS $BODY$
-- -------------------------------------
-- init
-- -------------------------------------
DECLARE
	v_now CONSTANT time without time zone = current_time;
	v_tr_date CONSTANT date = current_date;
BEGIN
/*

*/

	-- -------------------------------------
	-- validation
	-- -------------------------------------

	-- -------------------------------------
	-- process
	-- -------------------------------------
	RETURN QUERY (
		SELECT 
			a.product_id, a.product_desc, a.product_code, d.category_id, d.category_desc, a.product_tag, a.product_img_path, a.cost, 
			(e.qty - e.sold) AS avail
		FROM tb_product a
		INNER JOIN tb_meal_period_product b ON b.product_id = a.product_id
		INNER JOIN tb_meal_period c ON c.meal_period_id = b.meal_period_id
		INNER JOIN tb_prod_category d ON d.category_id = a.category_id
		INNER JOIN tb_product_availability e ON e.product_id = a.product_id
		WHERE 
			v_now between c.start_time AND c.end_time
			AND e.dt = v_tr_date
			AND a.is_in_use = 1
			AND c.is_in_use = 1
		ORDER BY
			a.product_code, a.product_desc
	);
	
	-- -------------------------------------
	-- cleanup
	-- -------------------------------------

END 
$BODY$;