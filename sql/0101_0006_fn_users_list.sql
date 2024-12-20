CREATE OR REPLACE FUNCTION fn_users_list (
	p_current_uid character varying(255),
	p_rid integer,
	p_axn character varying(255),
	p_url character varying(255),
	p_is_debug integer DEFAULT 0
) RETURNS TABLE (
	user_id uuid,
	modified_on timestamp,
	modified_by character varying(255),
	login_id text,
	user_name text,
	email text,
	user_group_id integer,
	user_group_desc character varying(255),
	is_active integer
)
LANGUAGE 'plpgsql'
AS $$
-- -------------------------------------
-- init
-- -------------------------------------
DECLARE

BEGIN
/* 0101_0006_fn_users_list

*/

	-- -------------------------------------
	-- validation
	-- -------------------------------------

	-- -------------------------------------
	-- process
	-- -------------------------------------
	RETURN QUERY (
		SELECT a.user_id, a.modified_on, a.modified_by, a.login_id, a.user_name, a.email, a.user_group_id, b.user_group_desc, a.is_active
		FROM tb_users a
		INNER JOIN tb_user_group b ON b.user_group_id = a.user_group_id
	);

	-- -------------------------------------
	-- cleanup
	-- -------------------------------------

END
$$;