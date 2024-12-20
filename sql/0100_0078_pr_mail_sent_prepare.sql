CREATE OR REPLACE PROCEDURE pr_mail_sent_prepare (
	IN p_current_uid character varying(255),
	OUT p_msg text,
	OUT p_mail_id uuid,
	IN p_mail_type_id integer,
	IN p_to text,
	IN p_cc text,
	IN p_bcc text,
	IN p_subject text,
	IN p_body text,
	IN p_attach_file text,
	IN p_fld_id1 text,
	IN p_fld_id2 text,
	IN p_fld_id3 text,
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
	new_body text;
BEGIN
/* 0100_0078_pr_mail_sent_prepare

	CALL pr_mail_sent_prepare (
	
	);

*/
	
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_mail_sent_prepare - start';
	END IF;
	
	-- -------------------------------------
	-- validation
	-- -------------------------------------
	
	-- -------------------------------------
	-- process
	-- -------------------------------------
	p_mail_id := gen_random_uuid();
	
	-- Default Template
	new_body := '
		<!DOCTYPE html>
		<html>
		<head>
		<style>
		body {margin: 0;padding: 0;font-family: Arial, sans-serif;background-color: #f4f4f4;}
		table {border-spacing: 0;width: 100%;}
		td {padding: 0;}
		img {border: 0;display: block;}
		.email-container {max-width: 600px;margin: 0 auto;background-color: #ffffff;border-radius: 8px;overflow: hidden;}
		.email-header {background-color: #007bff;padding: 20px;text-align: center;}
		.email-header img {width: 150px;}
		.email-body {padding: 20px;}
		.email-body h1 {font-size: 24px;color: #333333;margin-bottom: 10px;}
		.email-body p {font-size: 16px;color: #555555;line-height: 1.6;margin-bottom: 20px;}
		.email-footer {background-color: #f8f9fa;text-align: center;padding: 20px;font-size: 14px;color: #888888;}
		@media only screen and (max-width: 600px) {.email-container {width: 100% !important;}.email-header img {width: 120px;}}
		</style>
		</head>
		<body>
		<table role="presentation" class="email-container">
		<tr><td class="email-header"><img src="http://localhost:38998/sl/Logo.png" alt="Logo"></td></tr>
		<tr><td class="email-body">' || p_body || '</td></tr>
		<tr><td class="email-footer"><p>&copy; 2024 Your Company Name. All rights reserved.</p><p>If you no longer wish to receive emails, you can unsubscribe anytime.</p></td></tr>
		</table>
		</body>
		</html>
	';
	
	INSERT INTO tb_mail (
		mail_id, created_on, created_by, send_to, cc_to, bcc_to, subject, email_body, attach_file, mail_type_id, fld_id1, fld_id2, fld_id3, send_status, send_on
	) VALUES (
		p_mail_id, v_now, p_current_uid, p_to, p_cc, p_bcc, p_subject, new_body, p_attach_file, p_mail_type_id, p_fld_id1, p_fld_id2, p_fld_id3, 0, null
	);
	
	audit_log := 'Prepare Email - ' ||
					'Email Subject: ' || p_subject || ', ' ||
					'Email Body: ' || p_body || ', ' ||
					'Sent to: ' || p_to || ', ' ||
					'CC to: ' || p_cc || ', ' ||
					'Bcc to: ' || p_bcc || '.';
					
	p_msg := 'ok';
	
	-- Create Audit Log
	CALL pr_sys_append_audit_log (
		p_msg => audit_log
		, p_remarks => 'pr_mail_sent_prepare'
		, p_uid => p_current_uid
		, p_id1 => p_mail_id
		, p_id2 => null
		, p_id3 => null
        , p_app_id => null
		, p_module_code => module_code
	);
					
	 
	-- -------------------------------------
	-- cleanup
	-- -------------------------------------
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_mail_sent_prepare - end';
	END IF;

END
$BODY$;