CREATE OR REPLACE FUNCTION fn_product_availability_list (
	p_current_uid character varying(255),
	p_start_dt date,
	p_end_dt date,
	p_rid integer,
	p_axn character varying(255),
	p_url character varying(255),
	p_is_debug integer DEFAULT 0
) RETURNS TABLE (
	category_id uuid,
	category_desc character varying(255),
	product_id uuid,
	product_desc character varying(255),
	dt date,
	qty integer,
	sold integer,
	is_block integer,
	dow integer,
	is_weekend integer
)
LANGUAGE 'plpgsql'
AS $$
-- -------------------------------------
-- init
-- -------------------------------------
DECLARE
	v_msg text;
BEGIN
/* 0100_0069_fn_product_availability_list
		select * from tb_product_availability
		SELECT * From fn_product_availability_list (
			'tester',
			'2024-10-28',
			'2024-11-01',
			null,
			null,
			null
		);
*/

	-- -------------------------------------
	-- validation
	-- -------------------------------------
	IF p_start_dt > p_end_dt THEN
		RAISE NOTICE 'Invalid Date Range!!';
		RETURN;
	END IF;
	
	IF p_start_dt < fn_get_current_trans_dt() THEN
		RAISE NOTICE 'Cannot set pass date product availability!!';
		RETURN;
	END IF;
	
	IF p_start_dt IS NULL THEN
		p_start_dt := fn_get_current_trans_dt();
	END IF;
	
	IF p_end_dt IS NULL THEN
		p_end_dt := p_start_dt + INTERVAL '6 days';
	END IF;
	
	-- Initail the product availability date and product to list it out❗❗❗
	CALL pr_product_availability_init (
		p_current_uid => p_current_uid, 
		p_msg => v_msg, 
		p_start_dt => p_start_dt,
		p_end_dt => p_end_dt
	);
	
	IF v_msg <> 'ok' THEN 
		RAISE NOTICE 'Error in initial process!!';
	END IF;
	
	-- -------------------------------------
	-- process
	-- -------------------------------------
	RETURN QUERY (
		SELECT c.category_id, c.category_desc, a.product_id, b.product_desc, a.dt, a.qty, a.sold, a.is_block, a.dow, a.is_weekend
		FROM tb_product_availability a
		LEFT JOIN tb_product b ON b.product_id = a.product_id
		LEFT JOIN tb_prod_category c ON c.category_id = b.category_id
		WHERE a.dt BETWEEN p_start_dt AND p_end_dt
		ORDER BY a.dt, c.category_desc, b.product_desc
	);

	-- -------------------------------------
	-- cleanup
	-- -------------------------------------

END
$$;