CREATE OR REPLACE FUNCTION fn_rpt_bill_void (
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
	void_by character varying,
	order_no character varying,
	reason text,
	product_desc character varying,
	qty integer,
	amt numeric(15, 2)
)
LANGUAGE 'plpgsql'
AS $$
-- -------------------------------------
-- init
-- -------------------------------------
DECLARE
	audit_log text;
	module_code text;
BEGIN
/* 0300_0005_fn_rpt_bill_void

*/

	module_code := 'Report - Bill Void Report';

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
			a.void_by,
			a.doc_no AS order_no,
			a.remarks AS reason,
			c.product_desc,
			b.amt
		FROM tb_order_trans_void_log a
		INNER JOIN tb_order_trans_item_line b ON b.doc_no = a.doc_no
		INNER JOIN tb_product c ON c.product_id = b.product_id
		WHERE 
			a.tr_date BETWEEN p_start_dt AND p_end_dt
		ORDER BY
			a.tr_date, a.void_by, a.doc_no, c.product_desc
	);
	
	audit_log := 'Viewing or Printing Bill Void Report.';
	
	-- Create Audit Log
	CALL pr_sys_append_audit_log (
		p_msg => audit_log
		, p_remarks => 'fn_rpt_bill_void'
		, p_uid => p_current_uid
		, p_id1 => null
		, p_id2 => null
		, p_id3 => null
        , p_app_id => null
		, p_module_code => module_code
	); 
	
	-- -------------------------------------
    -- cleanup
    -- -------------------------------------

END
$$;