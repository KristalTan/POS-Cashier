CREATE OR REPLACE FUNCTION fn_country_list (
	p_current_uid character varying(255),
	p_is_in_use integer,
	p_rid integer,
	p_axn character varying(255),
	p_url character varying(255),
	p_is_debug integer DEFAULT 0
) RETURNS TABLE (
	country_id uuid,
	country_name character varying(255)
)
LANGUAGE 'plpgsql'
AS $$
-- -------------------------------------
-- init
-- -------------------------------------
DECLARE

BEGIN
/* 0100_0066_fn_country_list

*/

	-- -------------------------------------
	-- validation
	-- -------------------------------------

	-- -------------------------------------
	-- process
	-- -------------------------------------
	IF COALESCE(p_is_in_use, -1) = -1 THEN 
	
		RETURN QUERY (
			SELECT a.country_id, a.country_name
			FROM tb_country a
			ORDER BY a.display_seq, a.country_name
		);
	
	ELSE
	
		RETURN QUERY (
			SELECT a.country_id, a.country_name
			FROM tb_country a
			WHERE a.is_in_use = p_is_in_use
			ORDER BY a.display_seq, a.country_name
		);
	
	END IF;

	-- -------------------------------------
	-- cleanup
	-- -------------------------------------

END
$$;