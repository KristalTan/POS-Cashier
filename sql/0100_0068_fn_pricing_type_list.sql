CREATE OR REPLACE FUNCTION fn_pricing_type_list (
	p_current_uid character varying(255),
	p_is_in_use integer,
	p_rid integer,
	p_axn character varying(255),
	p_url character varying(255),
	p_is_debug integer DEFAULT 0
) RETURNS TABLE (
	pricing_type_id uuid,
	pricing_type_desc character varying(255)
)
LANGUAGE 'plpgsql'
AS $$
-- -------------------------------------
-- init
-- -------------------------------------
DECLARE

BEGIN
/* 0100_0068_fn_pricing_type_list

*/

	-- -------------------------------------
	-- validation
	-- -------------------------------------

	-- -------------------------------------
	-- process
	-- -------------------------------------
	IF COALESCE(p_is_in_use, -1) = -1 THEN 
	
		RETURN QUERY (
			SELECT a.pricing_type_id, a.pricing_type_desc
			FROM tb_pricing_type a
			ORDER BY a.display_seq, a.pricing_type_desc
		);
	
	ELSE
	
		RETURN QUERY (
			SELECT a.pricing_type_id, a.pricing_type_desc
			FROM tb_pricing_type a
			WHERE a.is_in_use = p_is_in_use
			ORDER BY a.display_seq, a.pricing_type_desc
		);
	
	END IF;

	-- -------------------------------------
	-- cleanup
	-- -------------------------------------

END
$$;