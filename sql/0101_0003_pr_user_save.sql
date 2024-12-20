CREATE OR REPLACE PROCEDURE pr_user_save (
	IN p_current_uid character varying(255),
	OUT p_msg text,
	INOUT p_user_id uuid,
	IN p_login_id text,
	IN p_user_name text,
	IN p_email text,
	IN p_pwd text,
	IN p_user_group_id integer,
	IN p_is_active integer,
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
	v_login_id_old text;
	v_user_name_old text;
	v_email_old text;
	v_pwd_old text;
	v_user_group_id_old integer;
	v_is_active_old integer;
BEGIN
/*

*/
	
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_user_save - start';
	END IF;
	
	module_code := 'User';
	
	-- -------------------------------------
	-- validation
	-- -------------------------------------
	IF LENGTH(COALESCE(p_user_name, '')) = 0 THEN
		p_msg := 'Username cannot be blank!!';
		RETURN;
	END IF;
	
	IF EXISTS (
		SELECT user_name 
		FROM tb_users
		WHERE
			user_name = p_user_name
			AND user_id <> fn_to_guid(p_user_id)
	) THEN
		p_msg := 'Username: ' || p_user_name || ' already exists!!';
		RETURN;
	END IF;
	
	IF LENGTH(COALESCE(p_login_id, '')) = 0 THEN
		p_msg := 'Login ID cannot be blank!!';
		RETURN;
	END IF;
	
	IF EXISTS (
		SELECT login_id 
		FROM tb_users
		WHERE
			login_id = p_login_id
			AND user_id <> fn_to_guid(p_user_id)
	) THEN
		p_msg := 'Login ID: ' || p_login_id || ' already exists!!';
		RETURN;
	END IF;
	
	IF LENGTH(COALESCE(p_email, '')) = 0 THEN
		p_msg := 'Email cannot be blank!!';
		RETURN;
	END IF;
	
	IF EXISTS (
		SELECT email 
		FROM tb_users
		WHERE
			email = p_email
			AND user_id <> fn_to_guid(p_user_id)
	) THEN
		p_msg := 'Email: ' || p_email || ' already exists!!';
		RETURN;
	END IF; 
	
	IF LENGTH(COALESCE(p_pwd, '')) = 0 THEN
		p_msg := 'Password cannot be blank!!';
		RETURN;
	END IF;
	
	IF NOT EXISTS (
		SELECT user_group_id 
		FROM tb_user_group
		WHERE user_group_id = p_user_group_id
	) THEN
		p_msg := 'Invalid User Group!!';
		RETURN;
	END IF; 

	-- -------------------------------------
	-- process
	-- -------------------------------------
	IF fn_to_guid(p_user_id) = fn_empty_guid() THEN
	
		p_user_id := gen_random_uuid();
		
		-- Insert new record
		-- Status_id can refer to tb_store_status
		INSERT INTO tb_users (
			user_id, created_on, created_by, modified_on, modified_by, status_id, login_id, user_name, email, pwd, user_group_id, is_active
		) VALUES (
			p_user_id, v_now, p_current_uid, v_now, p_current_uid, 1, p_login_id, p_user_name, p_email, p_pwd, p_user_group_id, COALESCE(p_is_active, 0)	
		);
		
		audit_log := 'Added new user: ' || p_user_name || '.';
	
	ELSE
	
		-- Get old record for audit log
		SELECT login_id, user_name, email, pwd, user_group_id, is_active
		INTO v_login_id_old, v_user_name_old, v_email_old, v_pwd_old, v_user_group_id_old, v_is_active_old
		FROM tb_users
		WHERE user_id = p_user_id;
		
		-- Update record
		UPDATE tb_users
		SET
			modified_on = v_now,
			modified_by = p_current_uid,
			login_id = p_login_id,
			user_name = p_user_name,
			email = p_email, 
			pwd = p_pwd,
			user_group_id = p_user_group_id,
			is_active = p_is_active
		WHERE user_id = p_user_id;
		
		audit_log := 'Updated Login ID from ' || v_login_id_old || ' to ' || p_login_id || ', ' ||
						'Updated Username from ' || v_user_name_old || ' to ' || p_user_name || ', ' ||
						'Updated Email from ' || v_email_old || ' to ' || p_email || ', ' ||
						'Updated Password from ' || v_pwd_old || ' to ' || p_pwd || ', ' ||
						'Updated User Group from ' || v_user_group_id_old || ' to ' || p_user_group_id || ', ' ||
						'Updated Is Active from ' || v_is_active_old || ' to ' || p_is_active || '.';

	END IF;
	
	p_msg := 'ok';
	
	-- Create Audit Log
	CALL pr_sys_append_audit_log (
		p_msg => audit_log
		, p_remarks => 'pr_user_save'
		, p_uid => p_current_uid
		, p_id1 => p_user_id
		, p_id2 => null
		, p_id3 => null
        , p_app_id => null
		, p_module_code => module_code
	); 

	-- -------------------------------------
	-- cleanup
	-- -------------------------------------
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_user_save - end';
	END IF;

END
$BODY$;