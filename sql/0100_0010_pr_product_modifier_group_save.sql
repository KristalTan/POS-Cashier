CREATE OR REPLACE PROCEDURE pr_product_modifier_group_save (
	IN p_current_uid character varying(255), 
	OUT p_msg text,
	INOUT p_modifier_group_id uuid,
	IN p_modifier_group_name character varying(255),
	IN p_is_single_modifier_choice integer,
	IN p_is_multiple_modifier_choice integer,
	IN p_is_in_use integer,
	IN p_display_seq character varying(6),
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
	v_modifier_group_name_old varchar(255);
	v_is_single_modifier_choice_old varchar(255);
	v_is_multiple_modifier_choice_old varchar(255);
	v_is_in_use_old integer;
	v_display_seq_old character varying(6);
BEGIN
/* 0100_0010_pr_product_modifier_group_save

	CALL pr_product_modifier_group_save (
		p_current_uid => 'tester',
		p_msg => null,
		p_modifier_group_id => null,
		p_modifier_group_name => 'Nasi Goreng',
		p_is_single_modifier_choice => 0,
		p_is_multiple_modifier_choice => 1
	);

*/

	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_product_modifier_group_save - start';
	END IF;
	
	module_code := 'Setting - Modifier Group';
	
	-- -------------------------------------
	-- validation
	-- -------------------------------------
	IF LENGTH(COALESCE(p_modifier_group_name, '')) = 0 THEN
		p_msg := 'Modifier Group Name cannot be blank!!';
		RETURN;
	END IF;
	
	IF EXISTS (
		SELECT *
		FROM tb_modifier_group
		WHERE 
			modifier_group_name = p_modifier_group_name
			AND modifier_group_id <> fn_to_guid(p_modifier_group_id)
	) THEN
		p_msg := 'Modifier Group Name: ' || p_modifier_group_name || ' already exists!!';
		RETURN;
	END IF;
	
	-- -------------------------------------
	-- process
	-- -------------------------------------
	IF fn_to_guid(p_modifier_group_id) = fn_empty_guid() THEN
	
		p_modifier_group_id := gen_random_uuid();
		
		-- Insert new record
		INSERT INTO tb_modifier_group (
			modifier_group_id, created_on, created_by, modified_on, modified_by, modifier_group_name, is_single_modifier_choice, is_multiple_modifier_choice,
			is_in_use, display_seq
		) VALUES (
			p_modifier_group_id, v_now, p_current_uid, v_now, p_current_uid, p_modifier_group_name, p_is_single_modifier_choice, p_is_multiple_modifier_choice,
			p_is_in_use, p_display_seq
		);
		
		-- Prepare Audit Log
		audit_log := 'Added Modifier Group: ' || p_modifier_group_name || '.';
	
	ELSE
		
		-- Get old record for audit log purpose
		SELECT modifier_group_name, is_single_modifier_choice, is_multiple_modifier_choice, is_in_use, display_seq
		INTO v_modifier_group_name_old, v_is_single_modifier_choice_old, v_is_multiple_modifier_choice_old, v_is_in_use_old, v_display_seq_old
		FROM tb_modifier_group
		WHERE modifier_group_id = p_modifier_group_id;
		
		-- Update record
		UPDATE tb_modifier_group
		SET	
			modified_on = v_now,
			modified_by = p_current_uid,
			modifier_group_name = p_modifier_group_name,
			is_single_modifier_choice = p_is_single_modifier_choice,
			is_multiple_modifier_choice = p_is_multiple_modifier_choice,
			is_in_use = p_is_in_use,
			display_seq = p_display_seq
		WHERE modifier_group_id = p_modifier_group_id;
	
		-- Prepare Audit Log
		audit_log := 'Update Modifier Group Name from ' || v_modifier_group_name_old || ' to ' || p_modifier_group_name || ', ' ||
						'Updated Single Modifier Choice from ' || v_is_single_modifier_choice_old || ' to ' || p_is_single_modifier_choice || ', ' ||
						'Update Multiple Modifier Choice from ' || v_is_multiple_modifier_choice_old || ' to ' || p_is_multiple_modifier_choice || ', ' ||
						'Update Is In Use from ' || v_is_in_use_old || ' to ' || p_is_in_use || ', ' ||
						'Update Display Sequence from ' || v_display_seq_old || ' to ' || p_display_seq || '.';
		
	END IF;
	
	p_msg := 'ok';
	
	-- Create Aufit Log
	CALL pr_sys_append_audit_log (
		p_msg => audit_log
		, p_remarks => 'pr_product_modifier_group_save'
		, p_uid => p_current_uid
		, p_id1 => p_modifier_group_id
		, p_id2 => null
		, p_id3 => null
        , p_app_id => null
		, p_module_code => module_code
	);
	
	-- -------------------------------------
	-- cleanup
	-- -------------------------------------
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_product_modifier_group_save - end';
	END IF;

END
$BODY$;