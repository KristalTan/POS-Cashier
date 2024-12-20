CREATE OR REPLACE PROCEDURE pr_notif_save (
	IN p_current_uid character varying(255),
	OUT p_msg text,
	INOUT p_notif_id uuid,
	IN p_action_id uuid,
	IN p_sent_to text,
	IN p_cc_to text,
	IN p_bcc_to text,
	IN p_subject text,
	IN p_body text,
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
	v_now CONSTANT timestamp = current_timestamp;
	module_code text;
	audit_log text;
	v_action_id_old uuid;
	v_sent_to_old text;
	v_cc_to_old text;
	v_bcc_to_old text;
	v_subject_old text;
	v_body_old text;
	v_is_in_use_old text;
BEGIN
/* 0100_0081_pr_notif_save

	CALL pr_notif_save (
		p_current_uid => 'tester',
		p_msg => null,
		p_notif_id => '8b363043-f24e-4cb5-822e-dc4398c29f07',
		p_action_id => '5a4b20a0-f7d3-425d-b093-022c8160eb6b',
		p_sent_to => 'chinleehao@gmail.com',
		p_cc_to => null,
		p_bcc_to => null,
		p_subject => '⚠️ Void Bill Notification',
		p_body => '<p>We are writing to inform you that a bill has been voided in the POS system by the cashier. Below are the details for your reference:</p>',
		p_is_in_use => 1,
		p_rid => null,
		p_axn => null,
		p_url => null 
	);

*/	

	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_notif_save - start';
	END IF;
	
	module_code := 'Notification';

	-- -------------------------------------
	-- validation
	-- -------------------------------------	
	IF NOT EXISTS (
		SELECT action_id 
		FROM tb_action
		WHERE 
			is_default_func = 0 
			AND is_in_use = 1
	) THEN
		p_msg := 'Invalid Action!!';
		RETURN;
	END IF;
	
	IF LENGTH(COALESCE(p_sent_to, '')) = 0 THEN
		p_msg := 'Send to cannot be blank!!';
		RETURN;
	END IF;
	
	IF LENGTH(COALESCE(p_subject, '')) = 0 THEN
		p_msg := 'Email subject cannot be blank!!';
		RETURN;
	END IF;
	
	IF LENGTH(COALESCE(p_body, '')) = 0 THEN
		p_msg := 'Email body cannot be blank!!';
		RETURN;
	END IF;

	-- -------------------------------------
	-- process
	-- -------------------------------------	
	IF fn_to_guid(p_notif_id) = fn_empty_guid() THEN
	
		p_notif_id := gen_random_uuid();
		
		INSERT INTO tb_notif (
			notif_id, created_on, created_by, modified_on, modified_by, action_id, sent_to, cc_to, bcc_to, subject, body, is_in_use
		) VALUES (
			p_notif_id, v_now, p_current_uid, v_now, p_current_uid, p_action_id, p_sent_to, p_cc_to, p_bcc_to, p_subject, p_body, p_is_in_use
		);
		
		audit_log := 'Added notification: ' || p_action_id || '.';
	
	ELSE 
	
		-- Get old record for audit log
		SELECT action_id, sent_to, cc_to, bcc_to, subject, body, is_in_use
		INTO v_action_id_old, v_sent_to_old, v_cc_to_old, v_bcc_to_old, v_subject_old, v_body_old, v_is_in_use_old
		FROM tb_notif
		WHERE notif_id = p_notif_id;
	
		-- Update Record
		UPDATE tb_notif
		SET
			modified_on = v_now, 
			modified_by = p_current_uid,
			action_id = p_action_id,
			sent_to = p_sent_to, 
			cc_to = p_cc_to, 
			bcc_to = p_bcc_to,
			subject = p_subject,
			body = p_body,
			is_in_use = p_is_in_use
		WHERE notif_id = p_notif_id;
		
		audit_log := 'Updated Notification - ' ||
						'Action from ' || v_action_id_old || ' to ' || p_action_id || ', ' ||
						'Send To from ' || v_sent_to_old || ' to ' || p_sent_to || ', ' ||
						'CC To from ' || v_cc_to_old || ' to ' || p_cc_to || ', ' ||
						'BCC To from ' || v_bcc_to_old || ' to ' || p_bcc_to || ', ' ||
						'Subject from ' || v_subject_old || ' to ' || p_subject || ', ' ||
						'Body from ' || v_body_old || ' to ' || p_body || ', ' ||
						'Is Active from ' || v_is_in_use_old || ' to ' || p_is_in_use || '.';
	
	END IF;
	
	p_msg := 'ok';
	
	-- Create Audit Log
	CALL pr_sys_append_audit_log (
		p_msg => audit_log
		, p_remarks => 'pr_notif_save'
		, p_uid => p_current_uid
		, p_id1 => p_notif_id
		, p_id2 => null
		, p_id3 => null
        , p_app_id => null
		, p_module_code => module_code
	); 

	-- -------------------------------------
	-- cleanup
	-- -------------------------------------
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_notif_save - end';
	END IF;

END
$BODY$;