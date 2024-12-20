CREATE OR REPLACE FUNCTION fn_general_setting_list (
	p_current_uid character varying(255),
	p_rid integer,
	p_axn character varying(255),
	p_url character varying(255),
	p_is_debug integer DEFAULT 0
) RETURNS TABLE (
	t text,
	v text
)
LANGUAGE 'plpgsql'
AS $$
-- -------------------------------------
-- init
-- -------------------------------------
DECLARE

BEGIN
/* 0100_0020_fn_general_setting_list

*/

	-- -------------------------------------
	-- validation
	-- -------------------------------------

	-- -------------------------------------
	-- process
	-- -------------------------------------
	RETURN QUERY (
		SELECT sys_setting_title, sys_setting_value
		FROM tb_sys_setting
		WHERE 
			can_customize = 1
			AND sys_setting_title <> 'smtp_mailbox_pwd'
		ORDER BY sys_setting_id
	);

	-- -------------------------------------
	-- cleanup
	-- -------------------------------------

END
$$;