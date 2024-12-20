CREATE OR REPLACE PROCEDURE pr_supplier_save (
	IN p_current_uid character varying(255),
	OUT p_msg text,
	INOUT p_supplier_id uuid,
	IN p_supplier_name character varying(255),
	IN p_phone_number character varying(50),
	IN p_mobile_number character varying(50),
	IN p_email character varying(50),
	IN p_fax character varying(50),
	IN p_addr_line_1 character varying(255),
	IN p_addr_line_2 character varying(255),
	IN p_city character varying(255),
	IN p_state character varying(255),
	IN p_post_code character varying(50),
	IN p_country character varying(255),
	IN p_display_seq character varying(6),
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
	v_supplier_name_old character varying(255);
	v_phone_number_old character varying(50);	
	v_mobile_number_old character varying(50); 
	v_email_old character varying(50); 
	v_fax_old character varying(50); 
	v_addr_line_1_old character varying(255);
	v_addr_line_2_old character varying(255); 
	v_city_old character varying(255); 
	v_state_old character varying(255); 
	v_post_code_old character varying(50); 
	v_country_old character varying(255); 
	v_display_seq_old character varying(6);
BEGIN 
/* 0100_0017_pr_supplier_save

-- Save/ Update Supplier
-- sample: 
	CALL pr_supplier_save (
		p_current_uid => 'tester',
		p_msg => null,
		p_supplier_id => null,
		p_supplier_name => 'ABC Supplier',
		p_phone_number => '028376590765443' ,
		p_mobile_number => '984765342345678',
		p_email => 'abcsupplier@gmai.com',
		p_fax => '4256789054345' ,
		p_addr_line_1 => '',
		p_addr_line_2 => '',
		p_city => '' ,
		p_state => '' ,
		p_post_code => '' ,
		p_country => '' ,
		p_display_seq => '000001' 
	);
*/

	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_supplier_save - start';
	END IF;
	
	module_code := 'Settings - Supplier';
	
	-- -------------------------------------
	-- validation
	-- -------------------------------------
	IF LENGTH(COALESCE(p_supplier_name, '')) = 0 THEN
		p_msg := 'Supplier Name cannot be blank!!';
		RETURN;
	END IF;

	IF EXISTS (
		SELECT *
		FROM tb_supplier
		WHERE 
			supplier_name = p_supplier_name
			AND supplier_id <> fn_to_guid(p_supplier_id)
	) THEN
		p_msg := 'Supplier Name: ' || p_supplier_name || ' already exist!!';
		RETURN;
	END IF;
	
	-- -------------------------------------
	-- process
	-- -------------------------------------
	IF fn_to_guid(p_supplier_id) = fn_empty_guid() THEN
		
		p_supplier_id = gen_random_uuid();
		
		-- Insert new record
		INSERT INTO tb_supplier (
			supplier_id, supplier_name, phone_number, mobile_number, email, fax, addr_line_1,
			addr_line_2, city, state, post_code, country, display_seq
		) VALUES (
			p_supplier_id, p_supplier_name, p_phone_number, p_mobile_number, p_email, p_fax,
			p_addr_line_1, p_addr_line_2, p_city, p_state, p_post_code, p_country, p_display_seq
		);
		
		-- Prepare Audit Log
		audit_log := 'Added Supplier Name: ' || p_supplier_name || '.';
		
	ELSE
	
		-- Get old record for audit log purpose
		SELECT 
			supplier_name, phone_number, mobile_number, email, fax, addr_line_1,
			addr_line_2, city, state, post_code, country, display_seq
		INTO 
			v_supplier_name_old, v_phone_number_old, v_mobile_number_old, v_email_old, v_fax_old,
			v_addr_line_1_old, v_addr_line_2_old, v_city_old, v_state_old, v_post_code_old, v_country_old,
			v_display_seq_old
		FROM tb_supplier
		WHERE supplier_id = p_supplier_id;
		
		-- Update Record
		UPDATE tb_supplier
		SET
			supplier_name = p_supplier_name, 
			phone_number = p_phone_number, 
			mobile_number = p_mobile_number, 
			email = p_email, 
			fax = p_fax, 
			addr_line_1 = p_addr_line_1,
			addr_line_2 = p_addr_line_2, 
			city = p_city, 
			state = p_state, 
			post_code = p_post_code, 
			country = p_country, 
			display_seq = p_display_seq
		WHERE supplier_id = p_supplier_id;
		
		-- Prepare Audit Log
		audit_log := 'Updated Supplier Name from ' || v_supplier_name_old || ' to ' || p_supplier_name || ', ' ||
						'Updated Phone Number from ' || v_phone_number_old || ' to ' || p_phone_number || ', ' ||
						'Updated Mobile Number from ' || v_mobile_number_old || ' to ' || p_mobile_number || ', ' ||
						'Updated Email from ' || v_email_old || ' to ' || p_email || ', ' ||
						'Updated Fax from ' || v_fax_old || ' to ' || p_fax || ', ' ||
						'Updated Address Line 1 from ' || v_addr_line_1_old || ' to ' || p_addr_line_1 || ', ' ||
						'Updated Address Line 2 from ' || v_addr_line_2_old || ' to ' || p_addr_line_2 || ', ' ||
						'Updated City from ' || v_city_old || ' to ' || p_city || ', ' ||
						'Updated State from ' || v_state_old || ' to ' || p_state || ', ' ||
						'Updated Post Code from ' || v_post_code_old || ' to ' || p_post_code || ', ' ||
						'Updated Country from ' || v_country_old || ' to ' || p_country || ', ' || 
						'Updated Display Sequence from ' || v_display_seq_old || ' to ' || p_display_seq || '.';
 	
	END IF;
	
	p_msg := 'ok';
	
	-- Create Audit Log
	CALL pr_sys_append_audit_log (
		p_msg => audit_log
		, p_remarks => ' pr_supplier_save'
		, p_uid => p_current_uid
		, p_id1 => p_supplier_id
		, p_id2 => null
		, p_id3 => null
        , p_app_id => null
		, p_module_code => module_code
	);
	
	-- -------------------------------------
	-- cleanup
	-- -------------------------------------
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_supplier_save - end';
	END IF;
	
END 
$BODY$;
