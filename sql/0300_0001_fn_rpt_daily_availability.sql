CREATE OR REPLACE FUNCTION fn_rpt_daily_availability (
	p_current_uid character varying(255),
	p_start_dt date,
	p_end_dt date,
	--p_product_id uuid,
	p_rid integer,
	p_axn character varying(255),
	p_url character varying(255),
	p_is_debug integer DEFAULT 0
) RETURNS TABLE (
	product_desc character varying(255), 
	category_desc character varying(255), 
	dt text, 
	qty integer, 
	sold integer
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
/* 0300_0001_fn_rpt_daily_availability

	SELECT * FROM fn_rpt_daily_availability (
		p_current_uid => 'tester',
		p_start_dt => '2024-12-04',
		p_end_dt => '2024-12-31',
		p_rid => null,
		p_axn => null,
		p_url => null
	);

*/

	module_code := 'Report - Daily Availability Report';

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
		SELECT b.product_desc, c.category_desc, to_char(a.dt, 'YYYY-MM-DD'), a.qty, a.sold
		FROM tb_product_availability a
		INNER JOIN tb_product b ON b.product_id = a.product_id
		INNER JOIN tb_prod_category c ON c.category_id = b.category_id
		WHERE a.dt between p_start_dt AND p_end_dt
		ORDER BY a.dt, c.category_desc, b.product_desc
	);
	
	audit_log := 'Viewing or Printing Daily Availability Report.';
	
	-- Create Audit Log
	CALL pr_sys_append_audit_log (
		p_msg => audit_log
		, p_remarks => 'fn_rpt_daily_availability'
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