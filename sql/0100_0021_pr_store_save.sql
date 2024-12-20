CREATE OR REPLACE PROCEDURE pr_store_save (
	IN p_current_uid character varying(255),
	OUT p_msg text,
	IN p_store_id uuid,
	IN p_store_code character varying(255),
	IN p_store_name character varying(255),
	IN p_addr_line_1 character varying(255),
	IN p_addr_line_2 character varying(255),
	IN p_city character varying(255),
	IN p_state uuid,
	IN p_post_code character varying(50),
	IN p_country uuid,
	IN p_phone_number character varying(50),
	IN p_email character varying(255),
	IN p_website character varying(255),
	IN p_gst_id character varying(255),
	IN p_sst_id character varying(255),
	IN p_business_registration_num character varying(255),
	IN p_receipt_temp_id uuid,
	IN p_curr_code character varying(50),
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
	v_store_code_old character varying(255);
	v_store_name_old character varying(255);
	v_addr_line_1_old character varying(255);
	v_addr_line_2_old character varying(255);
	v_city_old character varying(255);
	v_state_old uuid;
	v_post_code_old character varying(50);
	v_country_old uuid;
	v_phone_number_old character varying(50);
	v_email_old character varying(255);
	v_website_old character varying(255);
	v_gst_id_old character varying(255);
	v_sst_id_old character varying(255);
	v_business_registration_num_old character varying(255);
	v_receipt_temp_id_old uuid;
	v_curr_code_old character varying(50);
BEGIN
/* 0100_0021_pr_store_save

-- Save Store Profile
-- sample: 
	CALL pr_store_save (
		p_current_uid => 'tester',
		p_msg => null,
		p_store_id => '0f49bfb0-6414-43f1-bdc6-8c97a7290e6d',
		p_store_code => 'ABC',
		p_store_name => 'ABC Store',
		p_addr_line_1 => '',
		p_addr_line_2 => '',
		p_city => '',
		p_state => null,
		p_post_code => '',
		p_country => null,
		p_phone_number => '',
		p_email => '',
		p_website => '',
		p_gst_id => '',
		p_sst_id => '',
		p_business_registration_num => null,
		p_receipt_temp_id => '6d8d1f09-614b-4064-8fc3-d593f97939b2',
		p_curr_code => 'RM',
		p_rid => null,
		p_axn => null,
		p_url => null
	);
*/

	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_store_save - start';
	END IF;
	
	module_code := 'Settings - Store';
	
	-- -------------------------------------
	-- validation
	-- -------------------------------------
	IF LENGTH(COALESCE(p_store_code, '')) = 0 THEN
		p_msg := 'Store Code cannot be blank!!';
		RETURN;
	END IF;
	
	IF LENGTH(COALESCE(p_store_name, '')) = 0 THEN
		p_msg := 'Store Name cannot be blank!!';
		RETURN;
	END IF;
	
	IF LENGTH(COALESCE(p_receipt_temp_id::text, '')) = 0 THEN
		p_msg := 'Must Select the Receipt Template!!';
		RETURN;
	END IF;
	
	IF LENGTH(COALESCE(p_curr_code, '')) = 0 THEN
		p_msg := 'Currency Code cannot be blank!!';
		RETURN;
	END IF;

-- 	IF EXISTS (
-- 		SELECT *
-- 		FROM tb_store
-- 		WHERE 
-- 			store_name = p_store_name
-- 			AND store_id <> fn_to_guid(p_store_id)
-- 	) THEN
-- 		p_msg := 'Store Name: ' || p_store_name || ' already exists!!';
-- 		RETURN;
-- 	END IF;

-- 	IF EXISTS (
-- 		SELECT *
-- 		FROM tb_store
-- 		WHERE business_registration_num = p_business_registration_num
-- 	) THEN
-- 		p_msg := 'Business Registration Number already exists!!';
-- 		RETURN;
-- 	END IF;
	
	-- -------------------------------------
	-- process
	-- -------------------------------------
	IF fn_to_guid(p_store_id) = fn_empty_guid() THEN
	
		p_store_id := gen_random_uuid();
		
		-- Insert new reocrd
		INSERT INTO tb_store (
			store_id, created_on, created_by, modified_on, modified_by, store_name, addr_line_1,
			addr_line_2, city, state, post_code, country, phone_number, email, website, gst_id,
			sst_id, business_registration_num, receipt_temp_id, store_code, curr_code
		) VALUES (
			p_store_id, v_now, p_current_uid, v_now, p_current_uid, p_store_name, p_addr_line_1,
			p_addr_line_2, p_city, p_state, p_post_code, p_country, p_phone_number, p_email, p_website,
			p_gst_id, p_sst_id, p_business_registration_num, p_receipt_temp_id, p_store_code, p_curr_code
		);
		
		-- Prepare Audit Log
		audit_log := 'Added New Store: ' || p_store_name || '.';
	
	ELSE
	
		SELECT 
			store_name, addr_line_1, addr_line_2, city, state, 
			post_code, country, phone_number, email, website, gst_id,
			sst_id, business_registration_num, receipt_temp_id, store_code, curr_code
		INTO 
			v_store_name_old, v_addr_line_1_old, v_addr_line_2_old, v_city_old, v_state_old,
			v_post_code_old, v_country_old, v_phone_number_old, v_email_old, v_website_old,
			v_gst_id_old, v_sst_id_old, v_business_registration_num_old, v_receipt_temp_id_old, v_store_code_old, v_curr_code_old
		FROM tb_store
		WHERE store_id = p_store_id;
		
		UPDATE tb_store
		SET
			modified_on = v_now, 
			modified_by = p_current_uid, 
			store_name = p_store_name, 
			addr_line_1 = p_addr_line_1,
			addr_line_2 = p_addr_line_2, 
			city = p_city, 
			state = p_state, 
			post_code = p_post_code, 
			country = p_country, 
			phone_number = p_phone_number, 
			email = p_email, 
			website = p_website, 
			gst_id = p_gst_id,
			sst_id = p_sst_id, 
			business_registration_num = p_business_registration_num, 
			receipt_temp_id = p_receipt_temp_id,
			store_code = p_store_code,
			curr_code = p_curr_code
		WHERE store_id = p_store_id;
		
		audit_log := 'Updated Store Name from ' || v_store_name_old || ' to ' || p_store_name || ', ' ||
						'Updated Store Code from ' || v_store_code_old || ' to ' || p_store_code || ', ' ||
						'Updated Address Line 1 from ' || v_addr_line_1_old || ' to ' || p_addr_line_1 || ', ' ||
						'Updated Address Line 2 from ' || v_addr_line_2_old || ' to ' || p_addr_line_2 || ', ' ||
						'Updated City from ' || v_city_old || ' to ' || p_city || ', ' ||
						'Updated State from ' || v_state_old || ' to ' || p_state || ', ' ||
						'Updated Post Code from ' || v_post_code_old || ' to ' || p_post_code || ', ' ||
						'Updated Country from ' || v_country_old || ' to ' || p_country || ', ' ||
						'Updated Phone Number from ' || v_phone_number_old || ' to ' || p_phone_number || ', ' ||
						'Updated Email from ' || v_email_old || ' to ' || p_email || ', ' ||
						'Updated Webiste from ' || v_website_old || ' to ' || p_website || ', ' ||
						'Updated GST ID from ' || v_gst_id_old || ' to ' || p_gst_id || ', ' ||
						'Updated SST ID from ' || v_sst_id_old || ' to ' || p_sst_id || ', ' ||
						'Updated Business Registration Number from ' || v_business_registration_num_old || ' to ' || p_business_registration_num || ', ' ||
						'Updated Receipt Template from ' || v_receipt_temp_id_old || ' to ' || p_receipt_temp_id || ', '
						'Updated Currency Code from ' || v_curr_code_old || ' to ' || p_curr_code || '.';
	
	END IF;
	
	p_msg := 'ok';
	
	-- Create Audit Log
	CALL pr_sys_append_audit_log (
		p_msg => audit_log
		, p_remarks => 'pr_store_save'
		, p_uid => p_current_uid
		, p_id1 => p_store_id
		, p_id2 => null
		, p_id3 => null
        , p_app_id => null
		, p_module_code => module_code
	);
	
	-- -------------------------------------
	-- cleanup
	-- -------------------------------------
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_store_save - end';
	END IF;
	
END
$BODY$;