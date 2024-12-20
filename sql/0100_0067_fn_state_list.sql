CREATE OR REPLACE FUNCTION fn_state_list (
	p_current_uid character varying(255),
	p_is_in_use integer,
	p_rid integer,
	p_axn character varying(255),
	p_url character varying(255),
	p_is_debug integer DEFAULT 0
) RETURNS TABLE (
	state_id uuid,
	state_name character varying(255)
)
LANGUAGE 'plpgsql'
AS $$
-- -------------------------------------
-- init
-- -------------------------------------
DECLARE

BEGIN
/* 0100_0067_fn_state_list

*/

	-- -------------------------------------
	-- validation
	-- -------------------------------------

	-- -------------------------------------
	-- process
	-- -------------------------------------
	IF COALESCE(p_is_in_use, -1) = -1 THEN 
	
		RETURN QUERY (
			SELECT a.state_id, a.state_name
			FROM tb_state a
			ORDER BY a.display_seq, a.state_name
		);
	
	ELSE
	
		RETURN QUERY (
			SELECT a.state_id, a.state_name
			FROM tb_state a
			WHERE a.is_in_use = p_is_in_use
			ORDER BY a.display_seq, a.state_name
		);
	
	END IF;

	-- -------------------------------------
	-- cleanup
	-- -------------------------------------

END
$$;