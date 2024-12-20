CREATE OR REPLACE PROCEDURE pr_receipt_temp_save (
	IN p_current_uid character varying(255),
	OUT p_msg text,
	INOUT p_receipt_temp_id uuid,
	IN p_receipt_temp_name character varying(255),
	IN p_logo_img_path character varying(255),
	IN p_extra_information text,
	IN p_is_show_store_name integer,
	IN p_is_show_store_details integer,
	IN p_is_show_customer_details integer, 
	IN p_is_show_customer_point integer,
	IN p_is_in_use integer,
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
	v_receipt_temp_name_old character varying(255);
	v_logo_img_path_old character varying(255);
	v_extra_information_old text;
	v_is_show_store_name_old integer;
	v_is_show_store_details_old integer;
	v_is_show_customer_details_old integer;
	v_is_show_customer_point_old integer;
	v_is_in_use_old integer;
BEGIN
/* 0100_0030_pr_receipt_temp_save

*/
	
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_receipt_temp_save - start';
	END IF;
	
	module_code := 'Settings - Receipt Template';
	
	-- -------------------------------------
	-- validation
	-- -------------------------------------
	IF LENGTH(COALESCE(p_receipt_temp_name, '')) = 0 THEN
		p_msg := 'Receipt Template Name cannot be blank!!';
		RETURN;
	END IF;
	
	IF EXISTS (
		SELECT *
		FROM tb_receipt_temp
		WHERE 
			receipt_temp_name = p_receipt_temp_name
			AND receipt_temp_id <> fn_to_guid(p_receipt_temp_id)
	) THEN
		p_msg := 'Receipt Template Name: ' || p_receipt_temp_name || ' already exists!!';
		RETURN;
	END IF;
	
	-- -------------------------------------
	-- process
	-- -------------------------------------
	IF fn_to_guid(p_receipt_temp_id) = fn_empty_guid() THEN
	
		p_receipt_temp_id := gen_random_uuid();
		
		-- Insert new record
		INSERT INTO tb_receipt_temp (
			receipt_temp_id, created_on, created_by, modified_on, modified_by, receipt_temp_name, logo_img_path, extra_information, is_show_store_name, 
			is_show_store_details, is_show_customer_details, is_show_customer_point, is_in_use
		) VALUES (
			p_receipt_temp_id, v_now, p_current_uid, v_now, p_current_uid, p_receipt_temp_name, p_logo_img_path, p_extra_information, p_is_show_store_name,
			p_is_show_store_details, p_is_show_customer_details, p_is_show_customer_point, p_is_in_use
		);
		
		-- Preapre Audit Log
		audit_log := 'Added Receipt Template: ' || p_receipt_temp_name || '.';
	
	ELSE
	
		-- Get old record for audit log purpose
		SELECT receipt_temp_name, logo_img_path, extra_information, is_show_store_name, is_show_store_details, is_show_customer_details, is_show_customer_point, is_in_use
		INTO 
			v_receipt_temp_name_old, v_logo_img_path_old, v_extra_information_old, v_is_show_store_name_old, v_is_show_store_details_old, v_is_show_customer_details_old, 
			v_is_show_customer_point_old, v_is_in_use_old
		FROM tb_receipt_temp
		WHERE receipt_temp_id = p_receipt_temp_id;
		
		-- Update record
		UPDATE tb_receipt_temp
		SET
			receipt_temp_name = p_receipt_temp_name, 
			logo_img_path = p_logo_img_path, 
			extra_information = p_extra_information, 
			is_show_store_name = COALESCE(p_is_show_store_name, 0), 
			is_show_store_details = COALESCE(p_is_show_store_details, 0), 
			is_show_customer_details = COALESCE(p_is_show_customer_details, 0), 
			is_show_customer_point = COALESCE(p_is_show_customer_point, 0), 
			is_in_use = COALESCE(p_is_in_use, 0)
		WHERE receipt_temp_id = p_receipt_temp_id;
		
		-- Prepare Audit Log
		audit_log := 'Updated Receipt Template Name from ' || v_receipt_temp_name_old || ' to ' || p_receipt_temp_name || ', ' ||
						'Updated Logo Image Path from ' || v_logo_img_path_old || ' to ' || p_logo_img_path || ', ' ||
						'Updated Extra Information from ' || v_extra_information_old || ' to ' || p_extra_information || ', ' ||
						'Updated Show Store Name from ' || v_is_show_store_name_old || ' to ' || p_is_show_store_name || ', ' ||
						'Updated Show Store Details from ' || v_is_show_store_details_old || ' to ' || p_is_show_store_details || ', ' ||
						'Updated Show Customer Details from ' || v_is_show_customer_details_old || ' to ' || p_is_show_customer_details || ', ' ||
						'Updated Show Customer Point from ' || v_is_show_customer_point_old || ' to ' || p_is_show_customer_point || ', ' ||
						'Updated Is in Use from ' || v_is_in_use_old || ' to ' || p_is_in_use || '.';
	
	END IF;
	
	p_msg := 'ok';
	
	-- Create Audit Log
	CALL pr_sys_append_audit_log (
		p_msg => audit_log
		, p_remarks => 'pr_receipt_temp_save'
		, p_uid => p_current_uid
		, p_id1 => p_receipt_temp_id
		, p_id2 => null
		, p_id3 => null
        , p_app_id => null
		, p_module_code => module_code
	);
	
	-- -------------------------------------
	-- cleanup
	-- -------------------------------------
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_receipt_temp_save - end';
	END IF;
	
END
$BODY$;