CREATE OR REPLACE PROCEDURE pr_notif_save (
	IN p_current_uid character varying(255),
	OUT p_msg text,
	INOUT p_notif_id uuid,
	IN p_notif_type_id integer,
	IN p_sent_to text,
	IN p_cc_to text,
	IN p_bcc_to text,
	IN p_subject text,
	IN p_body text,
	IN p_is_in_use text,
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
BEGIN
/*

*/

	-- -------------------------------------
	-- validation
	-- -------------------------------------
	IF LENGTH(COALESCE(p_sent_to, '')) = 0 THEN
		p_msg := 'Send To cannot be blank!!';
		RETURN;
	END IF;
	
	IF LENGTH

	-- -------------------------------------
	-- process
	-- -------------------------------------

	-- -------------------------------------
	-- cleanup
	-- -------------------------------------

END
$BODY$;
