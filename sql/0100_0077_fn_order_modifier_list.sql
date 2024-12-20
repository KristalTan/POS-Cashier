CREATE OR REPLACE FUNCTION fn_order_modifier_list (
	p_current_uid character varying(255),
	p_product_id uuid,
	p_rid integer,
	p_axn character varying(255),
	p_url character varying(255),
	p_is_debug integer DEFAULT 0
) RETURNS TABLE (
	modifier_group_name character varying(255), 
	sing_c integer, 
	mult_c integer,
	modifier_option_id uuid, 
	modifier_option_name character varying(255), 
	addon_amt numeric(15, 4),
	is_default integer
)
LANGUAGE 'plpgsql'
AS $BODY$
-- -------------------------------------
-- init
-- -------------------------------------
DECLARE

BEGIN
/* 0100_0076_fn_order_modifier_list

*/

	-- -------------------------------------
	-- validation
	-- -------------------------------------

	-- -------------------------------------
	-- process
	-- -------------------------------------
	RETURN QUERY (
		SELECT 
			a.modifier_group_name, a.is_single_modifier_choice AS sing_c, a.is_multiple_modifier_choice AS mult_c, b.modifier_option_id, b.modifier_option_name, 
			b.addon_amt, b.is_default
		FROM tb_modifier_group a
		INNER JOIN tb_modifier_option b ON b.modifier_group_id = a.modifier_group_id
		INNER JOIN tb_modifier_item_link c ON c.modifier_group_id = a.modifier_group_id
		WHERE
			c.product_id = p_product_id
			AND a.is_in_use = 1
		ORDER BY a.modifier_group_name, b.modifier_option_name
	);

	-- -------------------------------------
	-- cleanup
	-- -------------------------------------

END 
$BODY$;