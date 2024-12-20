CREATE OR REPLACE FUNCTION public.fn_guest_list(
	p_current_uid character varying,
	p_rid integer,
	p_axn character varying(255),
	p_url character varying(255),
	p_is_debug integer DEFAULT 0
) RETURNS TABLE (
	guest_id uuid, 
	modified_on timestamp without time zone, 
	modified_by character varying, 
	first_name character varying, 
	last_name character varying, 
	full_name character varying, 
	title character varying, 
	gender character varying, 
	phone_number character varying, 
	email character varying, 
	dob date, 
	addr_line_1 character varying, 
	addr_line_2 character varying, 
	city character varying, 
	state_name character varying, 
	post_code character varying, 
	country_name character varying, 
	guest_tag character varying
) 
LANGUAGE 'plpgsql'
AS $$
-- -------------------------------------
-- init
-- -------------------------------------
DECLARE

BEGIN
/* 0100_0034_fn_guest_list
	
	select * from fn_guest_list('tester', 'setting');
*/

	-- -------------------------------------
	-- validation
	-- -------------------------------------

	-- -------------------------------------
	-- process
	-- -------------------------------------
	IF p_axn = 'setting' THEN
	
		RETURN QUERY(
			SELECT 
				a.guest_id, a.modified_on, a.modified_by, a.first_name, a.last_name, a.full_name, a.title, a.gender, a.phone_number, a.email, a.dob,
				a.addr_line_1, a.addr_line_2, a.city, b.state_name, a.post_code, c.country_name, a.guest_tag
			FROM tb_guest a
			LEFT JOIN tb_state b ON b.state_id = a.state
			LEFT JOIN tb_country c ON c.country_id = a.country
			ORDER BY 
				a.guest_tag, a.full_name
		);
	
	ELSE
	
		RETURN QUERY(
			SELECT 
				a.guest_id, NULL::timestamp AS modified_on, NULL::character varying AS modified_by, NULL::character varying AS first_name, 
				NULL::character varying AS last_name, a.full_name, a.title, NULL::character varying AS gender, NULL::character varying AS phone_number, 
				NULL::character varying AS email, NULL::date AS dob, NULL::character varying AS addr_line_1, NULL::character varying AS addr_line_2, 
            	NULL::character varying AS city, NULL::character varying AS state_name, NULL::character varying AS post_code, NULL::character varying AS country_name, 
				a.guest_tag
			FROM tb_guest a
			ORDER BY 
				a.guest_tag, a.full_name
		);
	
	END IF;

	-- -------------------------------------
	-- cleanup
	-- -------------------------------------

END
$$;
