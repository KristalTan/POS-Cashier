CREATE OR REPLACE FUNCTION fn_product_modifier_item_list (
	p_current_uid character varying(255),
	p_modifier_group_id uuid,
	p_rid integer,
	p_axn character varying(255),
	p_url character varying(255),
	p_is_debug integer DEFAULT 0
) RETURNS TABLE (
	modifier_option_id uuid,
	modified_on timestamp,
	modified_by character varying(255),
	modifier_group_id uuid,
	modifier_option_name character varying(255),
	addon_amt numeric(15, 4),
	is_default integer
)
LANGUAGE 'plpgsql'
AS $$
-- -------------------------------------
-- init
-- -------------------------------------
DECLARE

BEGIN
/* 0100_0014_fn_modifier_option_list

	SELECT *
	FROM fn_modifier_option_list (
		'tester',
		'ef78dbea-3315-4f1c-bc94-4c63a2c92627',
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
	RETURN QUERY (
		SELECT a.modifier_option_id, a.modified_on, a.modified_by, a.modifier_group_id, a.modifier_option_name, a.addon_amt, a.is_default
		FROM tb_modifier_option a
		WHERE (fn_to_guid(p_modifier_group_id) = fn_empty_guid() OR a.modifier_group_id = p_modifier_group_id)
		ORDER BY a.modifier_option_name, a.addon_amt
	);

	-- -------------------------------------
	-- cleanup
	-- -------------------------------------

END
$$;