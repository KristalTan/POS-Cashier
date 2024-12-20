CREATE OR REPLACE FUNCTION fn_product_modifier_group_item_link_list (
	p_current_uid character varying(255),
	p_modifier_group_id uuid,
	p_rid integer,
	p_axn character varying(255),
	p_url character varying(255),
	p_is_debug integer DEFAULT 0
) RETURNS TABLE (
	modifier_item_link_id uuid,
	modified_on timestamp,
	modified_by character varying(255),
	modifier_group_id uuid,
	product_id uuid,
	product_desc character varying(255)
)
LANGUAGE 'plpgsql'
AS $$
-- -------------------------------------
-- init
-- -------------------------------------
DECLARE

BEGIN
/* 0100_0016_fn_product_modifier_group_item_link_list

	select * from fn_product_modifier_group_item_link_list (
		'tester',
		'00b3a893-a452-4d72-9f89-2868683c2834',
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
		SELECT a.modifier_item_link_id, a.modified_on, a.modified_by, a.modifier_group_id, a.product_id, b.product_desc
		FROM tb_modifier_item_link a
		INNER JOIN tb_product b ON b.product_id = a.product_id
		WHERE (fn_to_guid(p_modifier_group_id) = fn_empty_guid() OR a.modifier_group_id = p_modifier_group_id)
		ORDER BY b.product_desc
	);

	-- -------------------------------------
	-- cleanup
	-- -------------------------------------

END
$$;