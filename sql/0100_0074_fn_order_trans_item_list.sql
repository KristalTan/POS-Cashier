CREATE OR REPLACE FUNCTION fn_order_trans_item_list (
	p_current_uid character varying(255),
	p_order_trans_id uuid,
	p_rid integer,
	p_axn character varying(50),
	p_url character varying(50),
	p_is_debug integer DEFAULT 0
) RETURNS TABLE (
	order_trans_item_line_id uuid, 
	modified_on text, 
	modified_by character varying, 
	tr_date text, 
	tr_type character varying, 
	tr_status character varying, 
	doc_no character varying, 
	product_id uuid, 
	product_desc character varying, 
	qty integer, 
	sell_price numeric(15, 4), 
	amt numeric(15, 2), 
	tax_code1 character varying, 
	tax_pct1 numeric(15, 2), 
	tax_amt1_calc numeric(15, 4), 
	tax_code2 character varying, 
	tax_pct2 numeric(15, 2), 
	tax_amt2_calc numeric(15, 4), 
	pymt_mode_id uuid,
	pymt_mode_desc character varying
) 
LANGUAGE 'plpgsql'
AS $$
-- -------------------------------------
-- init
-- -------------------------------------
DECLARE
BEGIN
/* 0100_0073_fn_order_trans_item_list

	SELECT *
	FROM fn_order_trans_item_list (
		p_current_uid => 'tester',
		p_order_trans_id => '9f1e591e-89ed-46ab-b07a-9e4602dab5c8',
		p_rid => null,
		p_axn => null,
		p_url => null
	);

*/

	-- -------------------------------------
	-- validation
	-- -------------------------------------

	-- -------------------------------------
	-- process
	-- -------------------------------------
	RETURN QUERY (
		SELECT 
			a.order_trans_item_line_id, to_char(a.modified_on, 'YYYY-MM-DD hh:MI:SS AM'), a.modified_by, to_char(a.tr_date, 'YYYY-MM-DD'), a.tr_type, a.tr_status, 
			a.doc_no, a.product_id, b.product_desc, a.qty, a.sell_price, a.amt, a.tax_code1, a.tax_pct1, a.tax_amt1_calc, a.tax_code2, a.tax_pct2, a.tax_amt2_calc, 
			a.pymt_mode_id, c.pymt_mode_desc
		FROM tb_order_trans_item_line a
		LEFT JOIN tb_product b ON b.product_id = a.product_id
		LEFT JOIN tb_pymt_mode c ON c.pymt_mode_id = a.pymt_mode_id
		WHERE a.order_trans_id = p_order_trans_id
		ORDER BY a.seq
	);

	-- -------------------------------------
	-- cleanup
	-- -------------------------------------

END
$$;