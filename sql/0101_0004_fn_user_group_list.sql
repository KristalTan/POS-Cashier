CREATE OR REPLACE FUNCTION fn_user_group_list (
	p_current_uid character varying(255),
	p_is_in_use integer,
	p_rid integer,
	p_axn character varying(255),
	p_url character varying(255),
	p_is_debug integer DEFAULT 0
) RETURNS TABLE (
	user_group_id uuid,
	modified_on timestamp,
	modified_by character varying(255),
	user_group_desc
)
LANGUAGE 'plpgsql'
AS $$
-- -------------------------------------
-- init
-- -------------------------------------
DECLARE

BEGIN
/* 

*/

	-- -------------------------------------
	-- validation
	-- -------------------------------------

	-- -------------------------------------
	-- process
	-- -------------------------------------
	IF COALESCE(p_is_in_use, -1) = -1 THEN
		
		RETURN QUERY (
			SELECT a.user_group_id, a.modified_on, a.modified_by, a.user_group_desc, a.is_in_use, a.display_seq
			FROM tb_user_group a
			WHERE a.user_group_id <> '-999'
			ORDER BY a.display_seq, a.user_group_desc
		);
		
	ELSE
	
		RETURN QUERY (
			SELECT 
				a.user_group_id, null::timestamp AS modified_on, null::character varying AS modified_by, a.user_group_desc, null::integer AS is_in_use, 
				null::character varying AS display_seq
			FROM tb_user_group a
			WHERE 
				a.user_group_id <> '-999'
				AND a.is_in_use = p_is_in_use
			ORDER BY a.display_seq, a.user_group_desc
		);
	
	END IF;
	
	-- -------------------------------------
	-- cleanup
	-- -------------------------------------

END
$$;