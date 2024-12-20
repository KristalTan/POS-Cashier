CREATE OR REPLACE FUNCTION fn_order_trans_table_list (
	p_current_uid character varying(255),
	--p_tr_date date,
	p_rid integer,
	p_axn character varying(50),
	p_url character varying(50),
	p_is_debug integer DEFAULT 0
) RETURNS TABLE (
	order_trans_table_id uuid, 
	table_section_name character varying, 
	table_desc character varying, 
	is_occ integer, 
	order_trans_id uuid, 
	doc_no character varying, 
	modified_on timestamp, 
	modified_by character varying, 
	tr_date date, 
	tr_type_desc character varying, 
	tr_status character varying, 
	amt numeric(15, 2), 
	pax integer
)
LANGUAGE 'plpgsql'
AS $$
-- -------------------------------------
-- init
-- -------------------------------------
DECLARE

BEGIN
/* 0100_0072_fn_order_trans_list
	-- List table location 
		--> Show which table is occ
		
	SELECT * FROM fn_order_trans_list (
		p_current_uid => 'tester',
		p_tr_date => '2024-11-22',
		p_rid => null,
		p_axn => null,
		p_url => null
	);

*/

	-- -------------------------------------
	-- validation
	-- -------------------------------------	
-- 	IF p_tr_date IS NULL THEN
-- 		p_tr_date := fn_get_current_trans_dt();
-- 	END IF;

	-- -------------------------------------
	-- process
	-- -------------------------------------
	
		RETURN QUERY (
			SELECT 
				a.order_trans_table_id, d.table_section_name, c.table_desc, a.is_occ, b.order_trans_id, b.doc_no, b.modified_on, b.modified_by, b.tr_date, 
				e.tr_type_desc, b.tr_status, b.amt, b.pax
			FROM tb_order_trans_table a 
			LEFT JOIN tb_order_trans b ON b.order_trans_id = a.order_trans_id
			LEFT JOIN tb_table c ON c.table_id = a.table_id
			LEFT JOIN tb_table_section d ON d.table_section_id = c.table_section_id
			LEFT JOIN tb_tr_type e ON e.tr_type_code = b.tr_type
			WHERE 
				b.tr_status = 'C'
				AND b.tr_type = 'TS'
				--AND b.tr_date = p_tr_date
				OR a.order_trans_id IS NULL
		);
	

	-- -------------------------------------
	-- cleanup
	-- -------------------------------------

	

END
$$;