CREATE OR REPLACE FUNCTION fn_modifier_group_list (
	p_current_uid character varying(255),
	p_is_in_use integer,
	p_rid integer,
	p_axn character varying(255),
	p_url character varying(255),
	p_is_debug integer DEFAULT 0
) RETURNS TABLE (
	modifier_group_id uuid,
	modified_on timestamp,
	modified_by character varying(255),
	modifier_group_name character varying(255),
	is_single_modifier_choice integer,
	is_multiple_modifier_choice integer,
	is_in_use integer,
	display_seq character varying(6)
)
LANGUAGE 'plpgsql'
AS $$
-- -------------------------------------
-- init
-- -------------------------------------
DECLARE
BEGIN
/* 0100_0011_fn_modifier_group_list
	
	SELECT * from fn_modifier_group_list ('tester', -1, null, '', '');
	
*/

	-- -------------------------------------
	-- validation
	-- -------------------------------------

	-- -------------------------------------
	-- process
	-- -------------------------------------
	IF COALESCE(p_is_in_use, -1) = -1 THEN
	
		RETURN QUERY (
			SELECT 
				a.modifier_group_id, a.modified_on, a.modified_by, a.modifier_group_name, a.is_single_modifier_choice, a.is_multiple_modifier_choice,
				a.is_in_use, a.display_seq
			FROM tb_modifier_group a
			ORDER BY 
				CASE 
					WHEN a.display_seq ~ '^\d+$' THEN CAST(a.display_seq AS INT)  -- If it's a number, convert to integer
					ELSE NULL  -- If it's not a number, set to NULL so we can sort non-numeric separately
				END,
				a.display_seq, a.modifier_group_name
		);
	
	ELSE
		
		RETURN QUERY (
			SELECT 
				a.modifier_group_id, null::timestamp AS modified_on, null::character varying AS modified_by, a.modifier_group_name, 
				a.is_single_modifier_choice, a.is_multiple_modifier_choice, null::integer AS is_in_use, null::character varying AS display_seq
			FROM tb_modifier_group a
			WHERE a.is_in_use = p_is_in_use
			ORDER BY 
				CASE 
					WHEN a.display_seq ~ '^\d+$' THEN CAST(a.display_seq AS INT)  -- If it's a number, convert to integer
					ELSE NULL  -- If it's not a number, set to NULL so we can sort non-numeric separately
				END,
				a.display_seq, a.modifier_group_name
		);
		
	END IF;

	-- -------------------------------------
	-- cleanup
	-- -------------------------------------
END
$$;
