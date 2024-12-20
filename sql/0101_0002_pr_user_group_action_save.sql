CREATE OR REPLACE PROCEDURE pr_user_group_action_save (
	IN p_current_uid character varying(255),
	OUT p_msg text,
	IN p_user_group_id integer,
	IN p_action_id uuid,
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
	p_user_group_action_id uuid;
BEGIN
/* 0101_0002_pr_user_group_action_save 

	
*/

	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_user_group_action_save - start';
	END IF;
	
	module_code := 'User - User Group Action';

	-- -------------------------------------
	-- validation
	-- -------------------------------------
	IF NOT EXISTS (
		SELECT user_group_id
		FROM tb_user_group
		WHERE 
			user_group_id = p_user_group_id
			AND is_in_use = 1 
	) THEN
		p_msg := 'Invalid User Group!!';
		RETURN;
	END IF;
	
	IF NOT EXISTS (
		SELECT action_id
		FROM tb_action 
		WHERE action_id = p_action_id
	) THEN
		p_msg := 'Invalid Action!!';
		RETURN;
	END IF;
	
	-- -------------------------------------
	-- process
	-- -------------------------------------
	IF NOT EXISTS (
		SELECT user_group_id, action_id
		FROM tb_user_group_action
		WHERE 
			user_group_id = p_user_group_id
			AND action_id = p_action_id
	) THEN
		
		p_user_group_action_id := gen_random_uuid();
		
		-- Insert new record
		INSERT INTO tb_user_group_action (
			user_group_action_id, user_group_id, action_id, created_on, created_by
		) VALUES (
			p_user_group_action_id, p_user_group_id, p_action_id, v_now, p_current_uid
		);
		
		audit_log := 'Added User Group Action: ' || p_action_id || ' to ' || p_user_group_id || '.';
		
	ELSE 
		
		-- Delete old record
		DELETE FROM tb_user_group_action WHERE user_group_id = p_user_group_id AND action_id = p_action_id;
		
		p_user_group_action_id := gen_random_uuid();
		
		-- Insert Again
		INSERT INTO tb_user_group_action (
			user_group_action_id, user_group_id, action_id, created_on, created_by
		) VALUES (
			p_user_group_action_id, p_user_group_id, p_action_id, v_now, p_current_uid
		);
		
		audit_log := 'Updated User Group Action: ' || p_action_id || ' to ' || p_user_group_id || '.';
	
	END IF;
	
	p_msg := 'ok';
	
	-- Create Audit Log
	CALL pr_sys_append_audit_log (
		p_msg => audit_log
		, p_remarks => 'pr_user_group_action_save'
		, p_uid => p_current_uid
		, p_id1 => p_user_group_action_id
		, p_id2 => null
		, p_id3 => null
        , p_app_id => null
		, p_module_code => module_code
	);

	-- -------------------------------------
	-- cleanup
	-- -------------------------------------
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_user_group_action_save - end';
	END IF;

END
$BODY$;