CREATE OR REPLACE PROCEDURE pr_mark_email_sent (
	IN p_current_uid character varying(255),
	OUT p_msg text,
	IN p_mail_id uuid,
	IN p_is_debug integer DEFAULT 0
)
LANGUAGE 'plpgsql'
AS $BODY$
-- -------------------------------------
-- init
-- -------------------------------------
DECLARE
	audit_log text;
	module_code text;
BEGIN
/*

*/
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_mark_email_sent - start';
	END IF;
	
	module_code := 'Email';

	-- -------------------------------------
	-- validation
	-- -------------------------------------
	IF NOT EXISTS (
		SELECT mail_id
		FROM tb_mail
		WHERE mail_id = p_mail_id
	) THEN
		p_msg := 'Invalid Mail!!';
		RETURN;
	END IF;
	
	-- -------------------------------------
	-- process
	-- -------------------------------------
	UPDATE tb_mail 
	SET 
		send_on = now(),
		send_status = 1
	WHERE mail_id = p_mail_id;
	
	audit_log := 'Email - ' || p_mail_id::text || ' sent on ' || now()::text || '.';
	
	-- Create Audit Log
	CALL pr_sys_append_audit_log (
		p_msg => audit_log
		, p_remarks => 'pr_mark_email_sent'
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
		RAISE NOTICE 'pr_mark_email_sent - end';
	END IF;

END
$BODY$;