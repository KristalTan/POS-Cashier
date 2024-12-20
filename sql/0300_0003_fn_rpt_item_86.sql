CREATE OR REPLACE FUNCTION fn_rpt_item_86 (
	p_current_uid character varying(255),
	p_start_dt date,
	p_end_dt date,
	--p_product_id uuid,
	p_rid integer,
	p_axn character varying(255),
	p_url character varying(255),
	p_is_debug integer DEFAULT 0
) RETURNS TABLE (
	tr_date date,
	category_desc character varying,
	product_code character varying,
	product_desc character varying,
	last_upd_on timestamp,
	last_upd_by character varying,
	qty integer,
	sold_qty integer
) 
LANGUAGE 'plpgsql'
AS $$
-- -------------------------------------
-- init
-- -------------------------------------
DECLARE

BEGIN
/* 0300_0003_fn_rpt_item_86
Hint: 
	--> Item 86: an item is no longer available

	SELECT * FROM fn_rpt_item_86 (
		p_current_uid => 'tester',
		p_start_dt => '2024-12-04',
		p_end_dt => '2024-12-11',
		p_rid => null,
		p_axn => null,
		p_url => null
	);

*/

	-- -------------------------------------
    -- validation
    -- -------------------------------------
	IF p_start_dt IS NULL THEN
		p_start_dt := fn_get_current_trans_dt();
	END IF;
	
	IF p_end_dt IS NULL THEN
		p_end_dt := fn_get_current_trans_dt() + INTERVAL '6 days';
	END IF;
	
	-- -------------------------------------
    -- process
    -- -------------------------------------
	RETURN QUERY (
		SELECT 
			b.dt AS tr_date,
			c.category_desc,
			a.product_code,
			a.product_desc,
			b.modified_on AS last_upd_on,
			b.modified_by AS last_upd_by,
			b.qty, 
			b.sold
		FROM tb_product a
		INNER JOIN tb_product_availability b ON b.product_id = a.product_id
		INNER JOIN tb_prod_category c ON c.category_id = a.category_id
		WHERE 
			a.is_enable_daily_avail = 1
			AND a.is_in_use = 1
			AND (
				b.qty = 0 OR (b.qty - b.sold) = 0
			) 
			AND b.dt BETWEEN p_start_dt AND p_end_dt
		ORDER BY
			b.dt, c.category_desc, a.product_code, a.product_desc, b.modified_on, b.modified_by
	);
		
	-- -------------------------------------
    -- cleanup
    -- -------------------------------------

END
$$;