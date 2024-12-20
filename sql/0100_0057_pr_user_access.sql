CREATE OR REPLACE PROCEDURE pr_user_login (
	IN p_lid character varying(255),
	IN p_pwd text,
	OUT p_msg text,
	OUT p_sess_id uuid,
	IN p_user_host character varying(255),
	IN p_browser_name character varying(255),
	IN p_os_platform character varying(50),
	IN p_browser_ver character varying(50),
	IN p_user_agent character varying(255),
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
	module_code text;
	audit_log text;
	v_user_id uuid;
	v_user_status_id integer;
	v_pwd text;
	v_user_group_id integer;
	v_status_id integer; 						-- 1: can access, 2: invalid account, 3: wrong pwd, 4: block
	v_ban_release_time timestamp;
	v_now2 timestamp;
	v_fail_cnt integer;
	v_last_fail_on timestamp;
	v_user_suspend_log_id uuid;
	v_logout_on timestamp;
BEGIN
/* 0100_0057_pr_user_login

*/
	
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_user_login - start';
	END IF;
	
	module_code := 'User Access - Login';

	-- -------------------------------------
	-- validation
	-- -------------------------------------
	IF NOT EXISTS (
		SELECT login_id 
		FROM tb_users 
		WHERE login_id = p_login_id 
	) THEN
		p_msg := 'Invalid Login ID!!';
		RETURN;
	END IF;
	
	-- -------------------------------------
	-- process
	-- -------------------------------------
	SELECT user_id, user_status_id, pwd, user_group_id
	INTO v_user_id, v_user_status_id, v_pwd, v_user_group_id
	FROM tb_users
	WHERE login_id = p_login_id;
	
	IF v_user_id IS NULL THEN
	
		v_status_id := 2;						-- Invalid Account
		audit_log := 'Failed to login system: Invalid User!!';
		p_msg := 'Invalid User!!';
		RETURN;
		
	ELSIF EXISTS (
		SELECT 
		FROM tb_user_status
		WHERE 
			user_status_id = v_user_status_id
			AND allow_login = 1
	) THEN 
	
		v_ban_release_time = v_now;
	
		IF EXISTS (
			SELECT *
			FROM tb_user_suspend
			WHERE 
				user_id = v_user_id
				AND ban_time > v_ban_release_time
		) THEN
		
			SELECT ban_time
			INTO v_ban_release_time
			FROM tb_user_suspend
			WHERE 
				user_id = v_user_id
			ORDER BY created_on DESC
			LIMIT 1;
			
			v_status_id := 3;						-- wrong pwd
			audit_log := 'Login ID ' || p_login_id || ' has been suspend!!';
			p_msg := 'Your Login ID has been suspend, please wait after ' || v_ban_release_time::text || ' to relogin again!!';
			RETURN;
		END IF;
		
		v_now2 := NOW() - INTERVAL '10 minutes';
		
		SELECT
			count(*), 
        	max(l.created_on) 
    	INTO
			v_fail_cnt, 
			v_last_fail_on 
		FROM tb_user_access_log l
		INNER JOIN tb_users u ON u.user_id = l.user_id
		WHERE 
			u.login_id = uid
			AND l.status_id = 3  -- wrong pwd
			AND l.created_on >= now;
			
		IF v_fail_cnt >= 10 THEN
		
			v_status_id := 3;						-- wrong pwd
			audit_log := 'Login ID ' || p_login_id || ' has been suspend!!';
			p_msg := 'Your Login ID has been suspend, please wait after ' || (v_now + INTERVAL '15 minutes')::text || ' to relogin again!!';
			
			IF NOT EXISTS (
				SELECT *
				FROM tb_user_suspend
				WHERE 
					user_id = v_user_id
					AND ban_time > v_ban_release_time
			) THEN
				
				v_ban_release_time = now() + INTERVAL '15 minutes';
				v_user_suspend_log_id := gen_random_uuid();
				
				INSERT INTO tb_user_suspend (
					user_suspend_log_id, created_on, created_by, user_id, ban_time
				) VALUES (
					v_user_suspend_log_id, v_now, p_login_id, v_user_id, v_ban_release_time
				);
				
				-- Create Audit Log
				CALL pr_sys_append_audit_log (
					p_msg => audit_log
					, p_remarks => 'pr_user_login'
					, p_uid => p_current_uid
					, p_id1 => v_user_suspend_log_id
					, p_id2 => null
					, p_id3 => null
					, p_app_id => null
					, p_module_code => module_code
				); 
				
			END IF;
			
			RETURN;
		
		END IF;
		
		-- Check IP
		
		-- Check Pwd
		IF v_pwd = p_pwd THEN
			
			v_status_id := 1;						-- valid owd, can access
			p_sess_id = gen_random_uuid();
			audit_log := 'Login ID: ' || p_login_id || ' has been login into the system!!';
			p_msg := 'ok';
			
		ELSE
		
			v_status_id := 3; 						-- wrong pwd
			audit_log := 'Access Deny - Invalid Password for ' || p_login_id || '.';
			p_msg := 'Invalid Password!!';

		END IF;
	
	ELSE
	
		v_status_id := 4;						-- block
		audit_log := 'Login ID: ' || p_login_id || ' has been blocked!!';
		p_msg := 'Login ID: ' || p_login_id || ' has been blocked!!';
	
	END IF;
	
	v_user_id := fn_to_guid(v_user_id);
	p_sess_id := fn_to_guid(p_sess_id);
	
	IF v_status_id <> 1 THEN
		v_logout_on := v_now;
	ELSE
		v_logout_on := null;
	END IF;
	
	INSERT INTO tb_user_access_log (
		created_on, login_id, user_id, sess_id, user_host, user_agent, last_access_on, logout_on, browser_name, os_platform, browser_version
	) VALUES (
		v_now, p_login_id, v_user_id, p_sess_id, p_user_host, p_user_agent, v_now, v_logout_on, p_browser_name, p_os_platform, p_browser_ver
	);
	
	-- Create Audit Log
	CALL pr_sys_append_audit_log (
		p_msg => audit_log
		, p_remarks => 'pr_user_login'
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
		RAISE NOTICE 'pr_user_login - end';
	END IF;

END
$BODY$;