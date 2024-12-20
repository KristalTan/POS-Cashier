CREATE OR REPLACE FUNCTION fn_invoice_listing_summ (
	p_current_uid character varying(255),
	p_start_dt date,
	p_end_dt date,
	p_rid integer,
	p_axn character varying(255),
	p_url character varying(255),
	p_is_debug integer DEFAULT 0
) RETURNS TABLE (
	tr_date date,
	meal_period_desc character varying,
	order_time time,
	order_no character varying,
	prod_amt numeric(15, 2),
	disc_pct numeric(15, 2),
	disc_amt numeric(15, 2),
	reason text,
	net_amt numeric(15, 2),
	tax_1 numeric(15, 2),
	tax_2 numeric(15, 2),
	rounding_amt numeric(15, 2),
	bill_amt numeric(15, 2),
	pymt_mode character varying,
	pymt_amt numeric(15, 2)
)
LANGUAGE 'plpgsql'
AS $$
-- -------------------------------------
-- init
-- -------------------------------------
DECLARE

BEGIN
/* 0300_0002_fn_invoice_listing_summ

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
			a.tr_date,
			c.meal_period_desc,
			a.created_on::time,
			a.doc_no, 
			(a.amt - a.total_tax - a.total_disc) AS prod_amt,
			a.discount_pct AS disc_pct,
			a.discount_amt AS disc_amt, 
			a.discount_remarks AS reason,
			(a.amt - a.total_tax + a.total_disc) AS net_amt,
			SUM(b.tax_amt1_calc) AS tax_1,
			SUM(b.tax_amt2_calc) AS tax_2,
			a.rounding_adj_amt AS rounding,
			a.amt AS bill_amt,
			d.pymt_mode_desc AS pymt_mode,
			CASE 
				WHEN b.pymt_mode_id <> fn_empty_guid() THEN a.amt 
				ELSE 0 
			END AS pymt_amt
		FROM tb_order_trans a
		LEFT JOIN tb_order_trans_item_line b ON b.order_trans_id = a.order_trans_id 
		LEFT JOIN tb_meal_period c ON a.created_on::time BETWEEN c.start_time AND c.end_time 
		LEFT JOIN tb_pymt_mode d ON d.pymt_mode_id = b.pymt_mode_id
		WHERE 
			a.tr_date BETWEEN p_start_dt AND p_end_dt
		GROUP BY 
			a.tr_date, c.meal_period_desc, a.created_on::time, 
			a.doc_no, a.amt, a.total_tax, a.total_disc, 
			a.discount_pct, a.discount_amt, a.discount_remarks, 
			a.rounding_adj_amt, d.pymt_mode_desc, b.pymt_mode_id
	);

	-- -------------------------------------
	-- cleanup
	-- -------------------------------------

END
$$;