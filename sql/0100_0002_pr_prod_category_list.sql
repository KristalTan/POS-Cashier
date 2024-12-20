CREATE OR REPLACE FUNCTION fn_prod_category_list (
	p_current_uid character varying(255),
	p_is_in_use integer,
	p_rid integer,
	p_axn character varying(255),
	p_url character varying(255),
	p_is_debug integer DEFAULT 0
) RETURNS TABLE (
	category_id uuid,
	modified_on timestamp,
	modified_by character varying(255),
    category_desc character varying(255),
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
/* 0100_0002_fn_prod_category_list

	SELECT * FROM fn_prod_category_list ('tester', 1, 0, null, null);

*/

	-- -------------------------------------
	-- validation
	-- -------------------------------------

	-- -------------------------------------
	-- process
	-- -------------------------------------
	
	IF COALESCE(p_is_in_use, -1) = -1 THEN 
		
		RETURN QUERY (
			SELECT a.category_id, a.modified_on, a.modified_by, a.category_desc, a.is_in_use, a.display_seq
			FROM tb_prod_category a
			ORDER BY
				CASE 
					WHEN a.display_seq ~ '^\d+$' THEN CAST(a.display_seq AS INT)  -- If it's a number, convert to integer
					ELSE NULL  -- If it's not a number, set to NULL so we can sort non-numeric separately
				END,
				a.display_seq, a.category_desc
		);
	
	ELSE 
	
		RETURN QUERY (
			SELECT 
				a.category_id, null::timestamp AS modified_on, null::character varying AS modified_by, a.category_desc, null::integer AS is_in_use, 
				null::character varying AS display_seq
			FROM tb_prod_category a
			WHERE a.is_in_use = 1
			ORDER BY
				CASE 
					WHEN a.display_seq ~ '^\d+$' THEN CAST(a.display_seq AS INT)  -- If it's a number, convert to integer
					ELSE NULL  -- If it's not a number, set to NULL so we can sort non-numeric separately
				END,
				a.display_seq, a.category_desc
		);
	
	END IF;

	-- -------------------------------------
	-- cleanup
	-- -------------------------------------

END
$BODY$;