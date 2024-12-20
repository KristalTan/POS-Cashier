CREATE OR REPLACE FUNCTION fn_table_section_list (
	p_current_uid character varying(255),
	p_is_in_use integer,
	p_rid integer,
	p_axn character varying(255),
	p_url character varying(255),
	p_is_debug integer DEFAULT 0
) RETURNS TABLE (
	table_section_id uuid,
	modified_on timestamp,
	modified_by character varying(255),
	table_section_name character varying(255),
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
/* 0100_0037_pr_table_section_list

*/

	-- -------------------------------------
	-- validation
	-- -------------------------------------

	-- -------------------------------------
	-- process
	-- -------------------------------------
	IF p_is_in_use = -1 THEN 
		
		RETURN QUERY (
			SELECT a.table_section_id, a.modified_on, a.modified_by, a.table_section_name, a.is_in_use, a.display_seq
			FROM tb_table_section a
			ORDER BY 
				CASE 
					WHEN a.display_seq ~ '^\d+$' THEN CAST(a.display_seq AS INT)  -- If it's a number, convert to integer
					ELSE NULL  -- If it's not a number, set to NULL so we can sort non-numeric separately
				END,	
				a.display_seq, a.table_section_name
		);
	
	ELSE
		
		RETURN QUERY (
			SELECT 
				a.table_section_id, null::timestamp AS modified_on, null::character varying AS modified_by, a.table_section_name, 
				null::integer AS is_in_use, null::character varying AS display_seq
			FROM tb_table_section a
			WHERE a.is_in_use = p_is_in_use
			ORDER BY 
				CASE 
					WHEN a.display_seq ~ '^\d+$' THEN CAST(a.display_seq AS INT)  -- If it's a number, convert to integer
					ELSE NULL  -- If it's not a number, set to NULL so we can sort non-numeric separately
				END,	
				a.display_seq, a.table_section_name
		);
	
	END IF;

	-- -------------------------------------
	-- cleanup
	-- -------------------------------------

END
$BODY$;