CREATE OR REPLACE FUNCTION fn_meal_period_list(
	p_current_uid character varying(255),
	p_is_in_use integer,
	p_rid integer,
	p_axn character varying(255),
	p_url character varying(255),
	p_is_debug integer DEFAULT 0
) RETURNS TABLE (
	meal_period_id uuid,
	modified_on timestamp,
	modified_by character varying(255),
	meal_period_desc character varying(255),
	start_time character varying(50),
	end_time character varying(50),
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
/* 0100_0005_pr_meal_period_list

	select * from fn_meal_period_list (
		'tester',
		-1,
		null,
		null,
		null
	);

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
				a.meal_period_id, a.modified_on, a.modified_by, a.meal_period_desc, LEFT(a.start_time::character varying, 5)::character varying AS start_time, 
				LEFT(a.end_time::character varying, 5)::character varying AS end_time, a.is_in_use, a.display_seq
			FROM tb_meal_period a
			ORDER BY 
				CASE 
					WHEN a.display_seq ~ '^\d+$' THEN CAST(a.display_seq AS INT)  -- If it's a number, convert to integer
					ELSE NULL  -- If it's not a number, set to NULL so we can sort non-numeric separately
				END,	
				a.display_seq, a.meal_period_desc
		);
	
	ELSE
	
		RETURN QUERY (
			SELECT 
				a.meal_period_id, null::timestamp AS modified_on, null::character varying AS modified_by, a.meal_period_desc, 
				null::character varying AS start_time, null::character varying AS end_time, null::integer AS is_in_use, null::character varying AS display_seq
			FROM tb_meal_period a
			WHERE a.is_in_use = p_is_in_use
			ORDER BY 
				CASE 
					WHEN a.display_seq ~ '^\d+$' THEN CAST(a.display_seq AS INT)  -- If it's a number, convert to integer
					ELSE NULL  -- If it's not a number, set to NULL so we can sort non-numeric separately
				END,	
				a.display_seq, a.meal_period_desc
		);
	
	END IF;

	-- -------------------------------------
	-- cleanup
	-- -------------------------------------

END
$$;