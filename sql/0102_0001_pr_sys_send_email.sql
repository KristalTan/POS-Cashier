CREATE OR REPLACE PROCEDURE pr_sys_send_email (
	IN p_current_uid character varying(255),
	OUT p_msg text,
	OUT p_mail_id uuid,
	IN p_mail_type_id integer,
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
	audit_log text;
	module_code text;
BEGIN
/*

*/

	-- -------------------------------------
	-- validation
	-- -------------------------------------
	
	-- -------------------------------------
	-- process
	-- -------------------------------------
	IF p_mail_type_id = 1 THEN
-- 		SELECT 
	END IF;
	
	p_mail_id := gen_random_uid();
	
	INSERT INTO tb_mail (
		mail_id, created_on, created_by, send_to, cc_to, subject, email_body, attach_file, mail_type_id, send_status, send_on
	) VALUES (
		p_mail_uid, v_now, p_current_uid, p_send_to, p_cc_to, p_bcc_to, p_subject, p_email_body, p_attach_file, p_mail_type_id, 0, null
	);
	
	-- Set output message
    p_msg := 'ok';
	
	-- -------------------------------------
	-- cleanup
	-- -------------------------------------

END
$BODY$;