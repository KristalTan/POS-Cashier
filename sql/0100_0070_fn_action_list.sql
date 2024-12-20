CREATE OR REPLACE FUNCTION fn_action_list (
	p_current_uid character varying(255),
	p_rid integer,
	p_axn character varying(255),
	p_url character varying(255),
	p_is_debug integer DEFAULT 0
) RETURNS TABLE (
	action_id uuid,
	action_desc text
) 
LANGUAGE 'plpgsql'
AS $$
-- -------------------------------------
-- init
-- -------------------------------------
DECLARE

BEGIN
/* 0100_0070_fn_action_list
	
	SELECT * from fn_action_list ('tester', null, null, null)

*/

	-- -------------------------------------
	-- validation
	-- -------------------------------------
	
	-- -------------------------------------
	-- process
	-- -------------------------------------
	RETURN QUERY (
		SELECT a.action_id, a.action_desc
		FROM tb_action a 
		WHERE 
			a.is_in_use = 1 
			AND a.is_default_func = 0
		ORDER BY 
			a.group_code, 
			a.display_seq
	);
	
	-- -------------------------------------
	-- cleanup
	-- -------------------------------------

END
$$;