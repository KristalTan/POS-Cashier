CREATE OR REPLACE FUNCTION fn_user_group_action_list (
	p_current_uid character varying(255),
	p_user_group_id integer,
	p_rid integer,
	p_axn character varying(255),
	p_url character varying(255),
	p_is_debug integer DEFAULT 0
) RETURNS TABLE (
	action_id uuid,
	action_desc character varying(255)
)
LANGUAGE 'plpgsql'
AS $$
-- -------------------------------------
-- init
-- -------------------------------------
DECLARE

BEGIN
/* 0101_0005_fn_user_group_action_list

*/

	-- -------------------------------------
	-- validation
	-- -------------------------------------

	-- -------------------------------------
	-- process
	-- -------------------------------------
	RETURN QUERY (
		SELECT a.action_id, b.action_desc
		FROM tb_user_group_action a
		LEFT JOIN tb_action b ON b.action_id = a.action_id
		WHERE a.user_group_id = p_user_group_id
		ORDER BY b.display_seq, b.action_desc
	);

	-- -------------------------------------
	-- cleanup
	-- -------------------------------------

END
$$;