CREATE OR REPLACE FUNCTION fn_supplier_list (
	p_current_uid character varying(255),
	p_is_in_use integer,
	p_is_debug integer DEFAULT 0
) RETURNS TABLE (
	supplier_id uuid,
	modified_on timestamp,
	modified_by character varying(255),
	supplier_name character varying(255),
	phone_number character varying(50),
	mobile_number character varying(50),
	email character varying(255),
	fax character varying(50),
	addr_line_1 character varying(255),
	addr_line_2 character varying(255),
	city character varying(255),
	state uuid,
	post_code character varying(50),
	country uuid,
	display_seq character varying(6)
)
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
-- -------------------------------------
-- init
-- -------------------------------------
BEGIN
/*
	0100_0018_pr_supplier_list
	
	select * from fn_supplier_list ('tester', -1)
*/	
	
	-- -------------------------------------
	-- validation
	-- -------------------------------------

	-- -------------------------------------
	-- process
	-- -------------------------------------
	IF p_is_in_use = -1 THEN 
	
		RETURN QUERY(
			SELECT 
				a.supplier_id, a.modified_on, a.modified_by, a.supplier_name, a.phone_number, a.mobile_number, a.email, a.fax, a.addr_line_1, a.addr_line_2,
				a.city, a.state, a.post_code, a.country, a.display_seq
			FROM tb_supplier a
			ORDER BY 
				a.display_seq, a.supplier_name
		);
	
	ELSE
		
		RETURN QUERY (
			SELECT 
				a.supplier_id, null AS modified_on, null AS modified_by, a.supplier_name, null AS phone_number, null AS mobile_number, null AS email, null AS fax, 
				null AS addr_line_1, null AS addr_line_2, null AS city, null AS state, null AS post_code, null AS country, null AS display_seq
			FROM tb_supplier a
			WHERE is_in_use = p_is_in_use
			ORDER BY 
				a.display_seq, a.supplier_name
		);

	END IF;
	
	-- -------------------------------------
	-- cleanup
	-- -------------------------------------


END
$BODY$;
