CREATE OR REPLACE PROCEDURE pr_product_modifier_item_save (
	IN p_current_uid character varying(255),
	OUT p_msg text,
	INOUT p_modifier_option_id uuid,
	IN p_modifier_group_id uuid,
	IN p_modifier_option_name character varying(255),
	IN p_addon_amt numeric(15, 2),
	IN p_is_default integer,
	IN p_rid integer,
	IN p_axn character varying(255),
	IN p_url character varying(255),
	IN p_is_debug integer DEFAULT 0
)
language 'plpgsql'
AS $BODY$
-- -------------------------------------
-- init
-- -------------------------------------
DECLARE
	v_now CONSTANT timestamp = localtimestamp;
	audit_log text;
	module_code text;
	v_modifier_group_id_old uuid;
	v_modifier_option_name_old character varying(255);
	v_addon_amt_old money;
	v_is_default_old integer;
BEGIN
/* 0100_0013_pr_product_modifier_item_save

	CALL pr_product_modifier_item_save (
		p_current_uid => 'tester',
		p_msg => null,
		p_modifier_option_id => null,
		p_modifier_group_id => '00b3a893-a452-4d72-9f89-2868683c2834',
		p_modifier_option_name => 'Telur Matar',
		p_addon_amt => 1,
		p_is_default => 0
	);

*/

	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_product_modifier_item_save - start';
	END IF;
	
	module_code := 'Settings - Modifier Group Item';
	
	-- -------------------------------------
	-- validation
	-- -------------------------------------
	IF LENGTH(COALESCE(p_modifier_option_name, '')) = 0 THEN
		p_msg := 'Option Name cannot be blank!!'
		RETURN;
	END IF;
	
	IF EXISTS (
		SELECT * 
		FROM tb_modifier_option
		WHERE 
			modifier_option_name = p_modifier_option_name
			-- Each Modifier Group cannot have same option name
			AND modifier_group_id = p_modifier_group_id
	) THEN
		p_msg := 'Option Name: ' || p_modifier_option_name || ' already exists!!';
		RETURN;
	END IF;
	
	IF NOT EXISTS (
		SELECT *
		FROM tb_modifier_group
		WHERE modifier_group_id = p_modifier_group_id
	) THEN
		p_msg := 'Invalid Modifier Group!!';
		RETURN;
	END IF;
	
	IF EXISTS (
		SELECT * 
		FROM tb_modifier_option
		WHERE  
			modifier_group_id = p_modifier_group_id
			AND is_default = 1
	) THEN
		p_msg := 'Only can set 1 option as default!!';
		RETURN;
	END IF;
	
	-- -------------------------------------
	-- process
	-- -------------------------------------
	IF fn_to_guid(p_modifier_option_id) = fn_empty_guid() THEN
	
		p_modifier_option_id := gen_random_uuid();
		
		-- Insert new record
		INSERT INTO tb_modifier_option (
			modifier_option_id, created_on, created_by, modified_on, modified_by, modifier_group_id, modifier_option_name, addon_amt, is_default
		) VALUES (
			p_modifier_option_id, v_now, p_current_uid, v_now, p_current_uid, p_modifier_group_id, p_modifier_option_name, p_addon_amt, p_is_default
		);
		
		-- Prepare Audit Log
		audit_log := 'Added Modifier Option: ' || p_modifier_option_name || ', Addon Amount: ' || p_addon_amt || '.';
	
	ELSE
	
		-- Get old record
		SELECT modifier_group_id, modifier_option_name, addon_amt, is_default
		INTO v_modifier_group_id_old, v_modifier_option_name_old, v_addon_amt_old, v_is_default_old
		FROM tb_modifier_option
		WHERE modifier_option_id = p_modifier_option_id;
		
		-- Update Record
		UPDATE tb_modifier_option
		SET	
			modified_on = v_now,
			modified_by = p_current_uid,
			modifier_group_id = p_modifier_group_id, 
			modifier_option_name = p_modifier_option_name,
			addon_amt = p_addon_amt,
			is_default = p_is_default
		WHERE modifier_option_id = p_modifier_option_id;
		
		audit_log := 'Updated Modifier Group from ' || v_modifier_group_id_old || ' to ' || p_modifier_group_id || ', ' ||
						'Updated Modifier Option Name from ' || v_modifier_option_name_old || ' to ' || p_modifier_option_name || ', ' ||
						'Updated Addon Amount from ' || v_addon_amt_old || ' to ' || p_addon_amt || ', ' ||
						'Updated Is Default from ' || v_is_default_old || ' to ' || p_is_default || '.';

	END IF;
	
	p_msg := 'ok';
	
	-- Create Audit Log
	CALL pr_sys_append_audit_log (
		p_msg => audit_log
		, p_remarks => 'pr_product_modifier_item_save'
		, p_uid => p_current_uid
		, p_id1 => p_modifier_option_id
		, p_id2 => null
		, p_id3 => null
        , p_app_id => null
		, p_module_code => module_code
	);
	
	-- -------------------------------------
	-- cleanup
	-- -------------------------------------
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_product_modifier_item_save - end';
	END IF;
	
END
$BODY$;
