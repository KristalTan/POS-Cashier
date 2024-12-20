CREATE OR REPLACE FUNCTION fn_product_list (
    p_current_uid character varying(255),
	--p_product_id uuid,
    p_is_in_use integer,
	p_rid integer,
    p_axn character varying(255),
	p_url character varying(255),
    p_is_debug integer DEFAULT 0
) 
RETURNS TABLE (
    product_id uuid,
    modified_on timestamp,
    modified_by character varying(255),
    product_desc character varying(255),
    product_code character varying(50),
    category_id uuid,
    product_tag character varying(255),
    product_img_path character varying(255),
    supplier_id uuid,
    pricing_type_id uuid,
    cost numeric(15, 4),
    sell_price numeric(15, 4),
    tax_code1 character varying(50),
    amt_include_tax1 integer,
    tax_code2 character varying(50),
    amt_include_tax2 integer,
    calc_tax2_after_tax1 integer,
    is_in_use integer,
    display_seq character varying(6),
    is_enable_kitchen_printer integer,
    is_allow_modifier integer,
    is_enable_track_stock integer,
    is_popular_item integer
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
/*
    select * from fn_product_list (
        'tester',
		'77e1b5fb-c40b-4e0c-8638-7b807589fa37',
        1,
		null,
        'order',
		''
    );
*/

    -- -------------------------------------
    -- validation
    -- -------------------------------------

    -- -------------------------------------
    -- process
    -- -------------------------------------
    IF p_axn = 'setting' THEN
        
        RETURN QUERY (
			SELECT 
				a.product_id, a.modified_on, a.modified_by, a.product_desc, a.product_code, a.category_id, a.product_tag, a.product_img_path,
				a.supplier_id, a.pricing_type_id, a.cost, a.sell_price, a.tax_code1, a.amt_include_tax1, a.tax_code2, a.amt_include_tax2,
				a.calc_tax2_after_tax1, a.is_in_use, a.display_seq, a.is_enable_kitchen_printer, a.is_allow_modifier, a.is_enable_track_stock, a.is_popular_item
			FROM tb_product a
			ORDER BY 
				a.display_seq, a.product_tag, a.product_code, a.product_desc
		);
            
    ELSIF p_axn = 'order' THEN
    
        RETURN QUERY (
			SELECT 
				a.product_id, null::timestamp AS modified_on, null::character varying modified_by, a.product_desc, a.product_code, a.category_id, 
				null::character varying AS product_tag, a.product_img_path, null::uuid AS supplier_id, null::uuid AS pricing_type_id, a.cost, a.sell_price, 
				a.tax_code1, a.amt_include_tax1, a.tax_code2, a.amt_include_tax2, a.calc_tax2_after_tax1, null::integer AS is_in_use, null::character varying AS display_seq, 
			a.is_enable_kitchen_printer, a.is_allow_modifier, a.is_enable_track_stock, a.is_popular_item
			FROM tb_product a			
			WHERE 
				a.is_in_use = 1
				--AND (fn_to_guid(p_product_id) = fn_empty_guid() OR a.product_id = p_product_id)
			ORDER BY 
				a.display_seq, a.product_tag, a.product_code, a.product_desc
		);
    
    END IF;

    -- -------------------------------------
    -- cleanup
    -- -------------------------------------

END
$BODY$;
