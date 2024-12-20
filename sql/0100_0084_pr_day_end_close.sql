CREATE OR REPLACE PROCEDURE pr_day_end_close (
	IN p_current_uid character varying(255),
	OUT p_msg text,
	OUT p_new_tr_dt text,
	IN p_remarks text,
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
	date_diff integer;
	curr_tr_dt date;
	v_action_id uuid;
	ct timestamp;
	v_sent_to text;
	v_cc_to text;
	v_bcc_to text;
	v_style text;
	v_subject text;
	v_body text;
	v_msg text;
	v_mail_id uuid;
BEGIN
/* 0100_0084_pr_day_end_close

*/

	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_day_end_close - start';
	END IF;
	
	module_code := 'Day End Closing';

	-- -------------------------------------
	-- validation
	-- -------------------------------------
	SELECT (dt - fn_get_current_trans_dt())
	INTO date_diff
	FROM tb_day_end_closing
	ORDER BY day_end_closing_id DESC
	LIMIT 1;

	IF date_diff < 0 THEN
		p_msg := 'Cannot do day end closing twice a day!!';
		RETURN;
	END IF;

	-- -------------------------------------
	-- process
	-- -------------------------------------
	curr_tr_dt = fn_get_current_trans_dt();
	p_new_tr_dt = (curr_tr_dt + INTERVAL '1 day')::text;
	
	-- Update Current Transaction Date
	UPDATE tb_sys_setting 
	SET sys_setting_value = p_new_tr_dt
	WHERE sys_setting_title = 'CURRENT_TRANS_DATE';
	
	INSERT INTO tb_day_end_closing (
		created_on, created_by, dt, remarks, start_time
	) VALUES (
		v_now, p_current_uid, curr_tr_dt, p_remarks, current_timestamp
	);
	
	-- Update complete time
	UPDATE tb_day_end_closing
	SET complete_time = current_timestamp
	WHERE dt = curr_tr_dt;
	
	SELECT complete_time
	INTO ct 
	FROM tb_day_end_closing
	WHERE dt = curr_tr_dt;
	
	audit_log := 'Day End Closing has been done on ' || ct::text || ', current transaction date change to ' || p_new_tr_dt || '.';
	
	p_msg := 'ok';
	
	-- Create Notification
	IF EXISTS (
		SELECT notif_id
		FROM tb_notif 
		WHERE action_id = v_action_id
		AND is_in_use = 1
	) THEN
		SELECT sent_to, cc_to, bcc_to, style, subject, body
		INTO v_sent_to, v_cc_to, v_bcc_to, v_style, v_subject, v_body
		FROM tb_notif
		WHERE action_id = v_action_id;
		
		-- Prepare Email
		CALL pr_mail_sent_prepare (
			p_current_uid => p_current_uid,
			p_msg => v_msg,
			p_mail_id => v_mail_id,
			p_mail_type_id => 1,
			p_to => v_sent_to,
			p_cc => v_cc_to,
			p_bcc => v_bcc_to,
			p_subject => v_subject,
			p_body => v_body,
			p_fld_id1 => p_new_tr_dt::text,
			p_fld_id2 => null,
			p_fld_id3 => null,
			p_attach_file => null
		);
		
		IF v_msg <> 'ok' THEN
			p_msg := 'Error happen during prepare mail!!';
			RETURN;
		END IF;
	END IF;
	
	-- Create Audit Log
	CALL pr_sys_append_audit_log (
		p_msg => audit_log
		, p_remarks => 'pr_day_end_close'
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
		RAISE NOTICE 'pr_day_end_close - end';
	END IF;

END
$BODY$;