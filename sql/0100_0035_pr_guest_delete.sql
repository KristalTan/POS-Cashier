CREATE OR REPLACE PROCEDURE pr_guest_delete (
	IN p_current_uid character varying(255),
	OUT p_msg text,
	IN p_guest_id uuid,
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
	v_phone_number_old character varying(50);
BEGIN
/* 0100_0035_pr_guest_delete
	
*/
	
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_guest_delete - start';
	END IF;
	
	module_code := 'Customer';
	
	-- -------------------------------------
	-- validation
	-- -------------------------------------
	IF NOT EXISTS (
		SELECT * 
		FROM tb_guest
		WHERE guest_id = p_guest_id
	) THEN
		p_msg := 'Customer is not exists!!';
		RETURN;
	END IF; 
	
	IF EXISTS (
		SELECT *
		FROM tb_order_trans
		WHERE guest_id = p_guest_id
	) THEN
		p_msg := 'Deletion is not allowed because customer has purchase history!!';
		RETURN;
	END IF;
	
	-- -------------------------------------
	-- process
	-- -------------------------------------
	
	-- Get old record for audit log purpose
	SELECT phone_number
	INTO v_phone_number_old
	FROM tb_guest
	WHERE guest_id = p_guest_id;
	
	-- Delete Record
	DELETE FROM tb_guest
	WHERE guest_id = p_guest_id;
	
	-- Prepare Audit Log
	audit_log := 'Delete Customer which Phone Number is ' || v_phone_number_old || '.';
	
	p_msg := 'ok';
	
	-- Create Audit Log
	CALL pr_sys_append_audit_log (
		p_msg => audit_log
		, p_remarks => 'pr_guest_delete'
		, p_uid => p_current_uid
		, p_id1 => p_guest_id
		, p_id2 => null
		, p_id3 => null
        , p_app_id => null
		, p_module_code => module_code
	);
	
	-- -------------------------------------
	-- cleanup
	-- -------------------------------------
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_guest_delete - end';
	END IF;

END
$BODY$;
