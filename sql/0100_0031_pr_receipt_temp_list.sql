CREATE OR REPLACE FUNCTION fn_receipt_temp_list (
	p_current_uid character varying(255),
	p_is_in_use integer,
	p_rid integer,
	p_axn character varying(255),
	p_url character varying(255),
	p_is_debug integer DEFAULT 0
) RETURNS TABLE (
	receipt_temp_id uuid,
	modified_on timestamp,
	modified_by character varying(255),
	receipt_temp_name character varying(255),
	logo_img_path character varying(255),
	extra_information text,
	is_show_store_name integer,
	is_show_store_details integer,
	is_show_customer_details integer,
	is_show_customer_point integer,
	is_in_use integer
)
LANGUAGE 'plpgsql'
AS $$
-- -------------------------------------
-- init
-- -------------------------------------
DECLARE

BEGIN
/* 0100_0031_pr_receipt_temp_list

*/

	-- -------------------------------------
	-- validation
	-- -------------------------------------

	-- -------------------------------------
	-- process
	-- -------------------------------------
	IF COALESCE(p_is_in_use, -1) = -1 THEN
	
		RETURN QUERY (
			SELECT 
				a.receipt_temp_id, a.modified_on, a.modified_by, a.receipt_temp_name, a.logo_img_path, a.extra_information, a.is_show_store_name,
				a.is_show_store_details, a.is_show_customer_details, a.is_show_customer_point, a.is_in_use
			FROM tb_receipt_temp a
			ORDER BY a.receipt_temp_name
		);
	
	ELSE
	
		RETURN QUERY (
			SELECT 
				a.receipt_temp_id, null::timestamp AS modified_on, null::character varying AS modified_by, a.receipt_temp_name, 
				null::character varying AS logo_img_path, null::text AS extra_information, null::integer AS is_show_store_name,
				null::integer AS is_show_store_details, null::integer AS is_show_customer_details, null::integer AS is_show_customer_point, 
				null::integer AS is_in_use
			FROM tb_receipt_temp a
			WHERE is_in_use = 1
			ORDER BY a.receipt_temp_name
		);

	END IF;

	-- -------------------------------------
	-- cleanup
	-- -------------------------------------

END
$$;