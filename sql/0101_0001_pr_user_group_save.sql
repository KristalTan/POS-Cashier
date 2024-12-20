CREATE OR REPLACE PROCEDURE pr_user_group_save (
	IN p_current_uid character varying(255),
	OUT p_msg text,
	IN p_user_group_id integer,
	IN p_user_group_desc character varying(255),
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
	v_now CONSTANT timestamp = current_timestamp;
	audit_log text;
	module_code text;
	v_user_group_desc_old character varying(255);
	v_is_in_use_old integer;
	v_display_seq_old character varying(6);
BEGIN
/* 0101_0001_pr_user_group_save

*/

	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_user_group_save - start';
	END IF;
	
	module_code := 'User - User Group';

	-- -------------------------------------
	-- validation
	-- -------------------------------------
	IF LENGTH(COALESCE(p_user_group_desc, '')) = 0 THEN 
		p_msg := 'User Group Description cannot be blank!!';
		RETURN;
	END IF;
			  
	IF EXISTS (
		SELECT user_group_desc
		FROM tb_user_group
		WHERE 
			user_group_desc = p_user_group_desc
			AND user_group_id <> p_user_group_id
	) THEN
		p_msg := 'User Group: ' || p_user_group_desc || ' already exists!!';
		RETURN;
	END IF;

	-- -------------------------------------
	-- process
	-- -------------------------------------
	IF fn_to_int_id(p_user_group_id) = 0 THEN
			  
		p_user_group_id := COALESCE((SELECT MAX(user_group_id) FROM tb_user_group), 0) + 1;
			  
		-- Insert new record
		INSERT INTO tb_user_group (
			user_group_id, created_on, created_by, modified_on, modified_by, user_group_desc, is_in_use, display_seq
		) VALUES (
			p_user_group_id, v_now, p_current_uid, v_now, p_current_uid, p_user_group_desc, COALESCE(p_is_in_use, 0), p_display_seq
		);
			  
		audit_log := 'Added new user group: ' || p_user_group_desc || '.';
		
	ELSE 
			  
		-- Get the old record for audit log purpose
		SELECT user_group_desc, is_in_use, display_seq
		INTO v_user_group_desc_old, v_is_in_use_old, v_display_seq_old
		FROM tb_user_group
		WHERE 
			user_group_id = p_user_group_id;
			  
		-- Update record
		UPDATE tb_user_group
		SET 
			modified_on = v_now,
			modified_by = p_current_uid,
			user_group_desc = p_user_group_id,
			is_in_use = p_is_in_use
		WHERE 
			user_group_id = p_user_group_id;
			  
		audit_log := 'Updated User Group Description from ' || v_user_group_desc_old || ' to ' || p_user_group_desc || ', '
			  			'Updated Is in use from ' || v_is_in_use_old || ' to ' || p_is_in_use || ', ' ||
						'Updated Display Sequence from ' || v_display_seq_old || ' to ' || p_display_seq || '.';
			  
	END IF;
			  
	p_msg := 'ok';
			  
	-- Create Audit Log
	CALL pr_sys_append_audit_log (
		p_msg => audit_log
		, p_remarks => 'pr_user_group_save'
		, p_uid => p_current_uid
		, p_id1 => null
		, p_id2 => null
		, p_id3 => null
        , p_app_id => null
		, p_module_code => module_code
	); 

	-- -------------------------------------
	-- cleanup
	-- -------------------------------------
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_user_group_save - end';
	END IF;

END
$BODY$;