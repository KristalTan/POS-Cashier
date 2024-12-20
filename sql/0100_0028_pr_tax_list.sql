CREATE OR REPLACE FUNCTION fn_tax_list (
	p_current_uid character varying(255),
	p_is_in_use integer,
	p_rid integer,
	p_axn character varying(255),
	p_url character varying(255),
	p_is_debug integer DEFAULT 0
) RETURNS TABLE (
	tax_id uuid,
	modified_on timestamp,
	modified_by character varying(255),
	tax_code character varying(50),
	tax_desc character varying(255),
	tax_pct numeric(15, 2),
	is_in_use integer,
	display_seq character varying(6)
)
LANGUAGE 'plpgsql'
AS $BODY$
-- -------------------------------------
-- init
-- -------------------------------------
DECLARE
BEGIN
/* 0100_0028_pr_tax_list

*/

	-- -------------------------------------
	-- validation
	-- -------------------------------------

	-- -------------------------------------
	-- process
	-- -------------------------------------
	IF p_is_in_use = -1 THEN
		
		RETURN QUERY (
			SELECT a.tax_id, a.modified_on, a.modified_by, a.tax_code, a.tax_desc, a.tax_pct, a.is_in_use, a.display_seq
			FROM tb_tax a
			ORDER BY 
				CASE 
					WHEN a.display_seq ~ '^\d+$' THEN CAST(a.display_seq AS INT)  -- If it's a number, convert to integer
					ELSE NULL  -- If it's not a number, set to NULL so we can sort non-numeric separately
				END,	
				a.display_seq, a.tax_code
		);
	
	ELSE
		
		RETURN QUERY (
			SELECT a.tax_id, null AS modified_on, null AS modified_by, a.tax_code, a.tax_desc, a.tax_pct, null AS is_in_use, null AS display_seq
			FROM tb_tax a
			WHERE a.is_in_use = p_is_in_use
			ORDER BY 
				CASE 
						WHEN a.display_seq ~ '^\d+$' THEN CAST(a.display_seq AS INT)  -- If it's a number, convert to integer
						ELSE NULL  -- If it's not a number, set to NULL so we can sort non-numeric separately
					END,	
				a.display_seq, a.tax_code
		);
	
	END IF;

	-- -------------------------------------
	-- cleanup
	-- -------------------------------------
	
END
$BODY$;