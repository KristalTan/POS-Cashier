CREATE OR REPLACE FUNCTION fn_get_mail_setting (
	store_id uuid,
	p_is_debug integer DEFAULT 0
) RETURNS TABLE (
	smtp_service text,
	smtp_mailbox text,
	smtp_client text,
	smtp_client_secret text,
	smtp_token text,
	smtp_able_service text
) 
LANGUAGE 'plpgsql'
COST 100
VOLATILE PARALLEL UNSAFE
ROWS 1000
AS $$
-- -------------------------------------
-- init
-- -------------------------------------
DECLARE
	v_smtp_service text;
	v_smtp_mailbox text;
	v_smtp_client text;
	v_smtp_client_secret text;
	v_smtp_token text;
	v_smtp_able_service text;
BEGIN
/* 0000_0010_fn_get_mail_setting

*/

	IF p_is_debug = 1 THEN
		RAISE NOTICE 'fn_get_mail_setting - start';
	END IF;

	-- -------------------------------------
	-- validation
	-- -------------------------------------
	
	-- -------------------------------------
	-- process
	-- -------------------------------------
	
	-- SMTP_SERVER
	SELECT sys_setting_value
	INTO v_smtp_service
	FROM tb_sys_setting
	WHERE sys_setting_title = 'SMTP_SERVICE';
	
	-- SMTP_SERVER
	SELECT sys_setting_value
	INTO v_smtp_mailbox
	FROM tb_sys_setting
	WHERE sys_setting_title = 'SMTP_MAILBOX';
	
	-- SMTP_SERVER
	SELECT sys_setting_value
	INTO v_smtp_client
	FROM tb_sys_setting
	WHERE sys_setting_title = 'SMTP_CLIENT';
	
	-- SMTP_SERVER
	SELECT sys_setting_value
	INTO v_smtp_client_secret
	FROM tb_sys_setting
	WHERE sys_setting_title = 'SMTP_CLIENT_SECRET';
	
	-- SMTP_SERVER
	SELECT sys_setting_value
	INTO v_smtp_token
	FROM tb_sys_setting
	WHERE sys_setting_title = 'SMTP_TOKEN';
	
	-- SMTP_SERVER
	SELECT sys_setting_value
	INTO v_smtp_able_service
	FROM tb_sys_setting
	WHERE sys_setting_title = 'IS_ACTIVE_MAIL_SERVICE';
	
	RETURN QUERY (
		SELECT
			v_smtp_service,
			v_smtp_mailbox,
			v_smtp_client,
			v_smtp_client_secret,
			v_smtp_token,
			v_smtp_able_service
	);
	
	-- -------------------------------------
	-- cleanup
	-- -------------------------------------
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'fn_get_mail_setting - end';
	END IF;

END
$$;