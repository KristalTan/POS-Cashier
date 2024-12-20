CREATE OR REPLACE PROCEDURE pr_guest_save (
	IN p_current_uid character varying(255),
	OUT p_msg text,
	INOUT p_guest_id uuid,
	IN p_first_name character varying(255),
	IN p_last_name character varying(255),
	IN p_full_name character varying(255),
	IN p_title character varying(50),
	IN p_gender character varying(255),
	IN p_phone_number character varying(50),
	IN p_email character varying(255),
	IN p_dob date,
	IN p_addr_line_1 character varying(255),
	IN p_addr_line_2 character varying(255),
	IN p_city character varying(255),
	IN p_state uuid,
	IN p_post_code character varying(50), 
	IN p_country uuid,
	IN p_guest_tag character varying(255),
	IN p_rid integer,
	IN p_axn character varying(255),
	IN p_url character varying(255),
	IN p_is_debug integer DEFAULT 0
)
LANGUAGE 'plpgsql'
AS $BODY$
-- -------------------------------------
-- init
-- -------------------------------------
DECLARE 
	v_now CONSTANT timestamp = localtimestamp;
	audit_log text;
	module_code text;
	v_first_name_old character varying(255);
	v_last_name_old character varying(255);
	v_full_name_old character varying(255);
	v_title_old character varying(50);
	v_gender_old character varying(50);
	v_phone_number_old character varying(50);
	v_email_old character varying(255);
	v_dob_old date;
	v_addr_line_1_old character varying(255);
	v_addr_line_2_old character varying(255);
	v_city_old character varying(255);
	v_state_old uuid;
	v_post_code_old character varying(50);
	v_country_old uuid;
	v_guest_tag_old character varying(255);
BEGIN
/* 0100_0033_pr_guest_save

*/

	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_guest_save - start';
	END IF;
	
	module_code := 'Customer';
	
	-- -------------------------------------
	-- validation
	-- -------------------------------------
	IF LENGTH(COALESCE(p_phone_numner, '')) = 0 THEN
		p_msg := 'Phone Number cannot be blank!!';
		RETURN;
	END IF;
	
	IF EXISTS (
		SELECT *
		FROM tb_general_setting
		WHERE is_compusory_guest_email = 1
	) THEN 
		IF LENGTH(COALESCE(p_email, '')) = 0 THEN
			p_msg := 'Email cannot be blank!!';
			RETURN;
		END IF;
	END IF;
	
	IF EXISTS (
		SELECT * 
		FROM tb_guest 
		WHERE phone_number = p_phone_number
	) THEN
		p_msg := 'Duplicate Phone Number!!';
		RETURN;
	END IF;
	
	IF EXISTS (
		SELECT *
		FROM tb_guest 
		WHERE email = p_email
	) THEN
		p_msg := 'Duplicate Email ID!!';
		RETURN;
	END IF;
	
	-- -------------------------------------
	-- process
	-- -------------------------------------
	IF fn_to_guid(p_guest_id) = fn_empty_guid() THEN
	
		p_guest_id := gen_random_uuid();
		
		-- Insert new record
		INSERT INTO tb_guest (
			guest_id, created_on, created_by, modified_on, modified_by, first_name, last_name, full_name, title, gender, phone_number, email, dob, 
			addr_line_1, addr_line_2, city, state, post_code, country, guest_tag
		) VALUES (
			p_guest_id, v_now, p_current_uid, v_now, p_current_uid, p_first_name, p_last_name, p_full_name, p_title, p_gender, p_phone_number, p_email, p_dob, 
			p_addr_line_1, p_addr_line_2, p_city, p_state, p_post_code, p_country, p_guest_tag
		);
		
		-- Prepare Audit Log
		audit_log := 'Added Customer with Phone Number: ' || p_phone_number || '.';
	
	ELSE
		
		-- Get old record for audit log purpose
		SELECT first_name, last_name, full_name, title, gender, phone_number, email, dob, addr_line_1, addr_line_2, city, state, post_code, country, guest_tag
		INTO 
			v_first_name_old, v_last_name_old, v_full_name_old, v_title_old, v_gender_old, v_phone_number_old, v_email_old, v_dob_old, v_addr_line_1_old, 
			v_addr_line_2_old, v_city_old, v_state_old, v_post_code_old, v_country_old, v_guest_tag_old
		FROM tb_guest
		WHERE guest_id = p_guest_id;
		
		-- Update Record
		UPDATE tb_guest
		SET 
			first_name = p_first_name,
			last_name = p_last_name, 
			full_name = p_full_name, 
			title = p_title, 
			gender = p_gender,
			phone_number = p_phone_number, 
			email = p_email, 
			dob = p_dob, 
			addr_line_1 = p_addr_line_1, 
			addr_line_2 = p_addr_line_2, 
			city = p_city, 
			state = p_state, 
			post_code = p_post_code, 
			country = p_country, 
			guest_tag = p_guest_tag
		WHERE guest_id = p_guest_id;
		
		-- Prepare Audit log
		audit_log := 'Updated First Name from ' || v_first_name_old || ' to ' || p_first_name || ', ' ||
						'Updated Last Name from ' || v_last_name_old || ' to ' || p_last_name || ', ' ||
						'Updated Full Name from ' || v_full_name_old || ' to ' || p_full_name || ', ' ||
						'Updated Title from ' || v_title_old || ' to ' || p_title || ', ' ||
						'Updated Gender from ' || v_gender_old || ' to ' || p_gender || ', ' ||
						'Updated Phone Number from ' || v_phone_number_old || ' to ' || p_phone_number || ', ' ||
						'Updated Email from ' || v_email_old || ' to ' || p_email || ', ' ||
						'Updated Date of Birth from ' || v_dob_old || ' to ' || p_dob || ', ' ||
						'Updated Address Line 1 from ' || v_addr_line_1_old || ' to ' || p_addr_line_1 || ', ' ||
						'Updated Address Line 2 from ' || v_addr_line_2_old || ' to ' || p_addr_line_2 || ', ' ||
						'Updated City from ' || v_city_old || ' to ' || p_city || ', ' ||
						'Updated State from ' || v_state_old || ' to ' || p_state || ', ' ||
						'Updated Post Code from ' || v_post_code_old || ' to ' || p_post_code || ', ' ||
						'Updated Country from ' || v_country_old || ' to ' || p_country || ', ' ||
						'Updated Guest Tag from ' || v_guest_tag_old || ' to ' || p_guest_tag || '.';
		
	END IF;
	
	p_msg := 'ok';
	
	-- Create Audit Log
	CALL pr_sys_append_audit_log (
		p_msg => audit_log
		, p_remarks => 'pr_guest_save'
		, p_uid => p_current_uid
		, p_id1 => p_guest_id
		, p_id2 => null
		, p_id3 => null
        , p_app_id => null
		, p_module_code => module_code
	);
	
	-- -------------------------------------
	-- cleanup
	-- -------------------------------------
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_guest_save - end';
	END IF;
	
END
$BODY$;