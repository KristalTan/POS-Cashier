CREATE OR REPLACE FUNCTION fn_store_list (
	p_current_uid character varying(255),
	p_rid integer,
	p_axn character varying(255),
	p_url character varying(255),
	p_is_debug integer DEFAULT 0
) RETURNS TABLE (
	store_id uuid,
	store_name character varying(255),
	addr_line_1 character varying(255),
	addr_line_2 character varying(255),
	city character varying(255),
	state_name character varying(255),
	post_code character varying(50),
	country_name character varying(255),
	phone_number character varying(50),
	email character varying(255),
	website character varying(255),
	gst_id character varying(255),
	sst_id character varying(255),
	business_registration_num character varying(255),
	receipt_temp_desc character varying(255)
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
	RETURN QUERY (
		select 
			a.store_id, a.store_name, a.addr_line_1, a.addr_line_2, a.city, b.state_name, a.post_code, c.country_name,
			a.phone_number ,a.email, a.website, a.gst_id, a.sst_id, a.business_registration_num, d.receipt_temp_name
		from tb_store a
		LEFT JOIN tb_state b ON b.state_id = a.state
		LEFT JOIN tb_country c ON c.country_id = a.country
		LEFT JOIN tb_receipt_temp d ON d.receipt_temp_id = a.receipt_temp_id
	);

	-- -------------------------------------
	-- cleanup
	-- -------------------------------------

END
$$;