CREATE OR REPLACE PROCEDURE pr_pos_printer_save (
	IN p_current_uid character varying(255),
	OUT p_msg text,
	INOUT p_pos_printer_id uuid,
	IN p_printer_code character varying(50),
	IN p_printer_name character varying(255),
	IN p_is_in_use integer,
	IN p_display_seq character varying(6),
	IN p_is_default integer,
	IN p_printer_type_id integer,
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
	v_printer_code_old character varying(50);
	v_printer_name_old character varying(50);
	v_is_in_use_old integer;
	v_display_seq_old character varying(5);
	v_is_default_old integer;
	v_printer_type_id_old integer;
	v_action_id uuid;
BEGIN
/* 0100_0059_pr_pos_printer_save

*/

	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_pos_printer_save - start';
	END IF;
	
	module_code := 'Setting - Pos Printer';
-- 	v_action_id := ''

	-- -------------------------------------
	-- validation
	-- -------------------------------------
	
	-- Role Validation
-- 	IF NOT EXISTS (
-- 		SELECT 
-- 		FROM tb
-- 	)
	
	IF LENGTH(COALESCE(p_printer_code, '')) = 0 THEN
		p_msg := 'Printer Code cannot be blank!!';
		RETURN;
	END IF;
	
	IF EXISTS (
		SELECT printer_code
		FROM tb_pos_printer
		WHERE 
			printer_code = p_printer_code
			AND pos_printer_id <> fn_to_guid(p_pos_printer_id)
	) THEN
		p_msg := 'Pos Printer Code: ' || p_printer_code || ' already exists!!';
		RETURN;
	END IF;
	
	IF LENGTH(COALESCE(p_printer_name, '')) = 0 THEN
		p_msg := 'Printer Name cannot be blank!!';
		RETURN;
	END IF;
	
	IF EXISTS (
		SELECT printer_name
		FROM tb_pos_printer
		WHERE 
			printer_name = p_printer_name
			AND pos_printer_id <> fn_to_guid(p_pos_printer_id)
	) THEN
		p_msg := 'Pos Printer Name: ' || p_printer_name || ' already exists!!';
		RETURN;
	END IF;
	
	IF EXISTS (
		SELECT printer_type_id
		FROM tb_printer_type
		WHERE printer_type_id = p_printer_type_id
	) THEN
		p_msg := 'Invalid Printer Type!!';
		RETURN;
	END IF;
	
	-- -------------------------------------
	-- process
	-- -------------------------------------
	IF fn_to_guid(p_pos_printer_id) <> fn_empty_guid() THEN
	
		p_pos_printer_id := gen_random_uuid();
		
		-- Insert new record
		INSERT INTO tb_pos_printer (
			pos_printer_id, created_on, created_by, modified_on, modified_by, printer_code, printer_name, is_in_use, display_seq, is_default, printer_type_id
		) VALUES (
			p_pos_printer_id, v_now, p_current_uid, v_now, p_current_uid, p_printer_code, p_printer_name, p_is_in_use, p_display_seq, p_is_default, p_printer_type_id
		);
		
		audit_log := 'Added Pos Printer: ' || p_printer_name || '.';
	
	ELSE 
	
		-- Get old record for audit log purpose
		SELECT printer_code, printer_name, is_in_use, display_seq, is_default, printer_type_id
		INTO v_printer_code_old, v_printer_name_old, v_is_in_use_old, v_display_seq_old, v_is_default_old, v_printer_type_id_old
		FROM tb_pos_printer
		WHERE pos_printer_id = p_pos_printer_id;
		
		-- Update record
		UPDATE tb_pos_printer
		SET
			modified_on = v_now,
			modified_by = p_current_uid,
			printer_code = p_printer_code,
			printer_name = p_printer_name,
			is_in_use = p_is_in_use,
			display_seq = p_display_seq,
			is_default = p_is_default,
			printer_type_id = p_printer_type_id
		WHERE pos_printer_id = p_pos_printer_id;
		
		audit_log := 'Updated Printer Code from ' || v_printer_code_old || ' to ' || p_printer_code || ', ' ||
						'Updated Printer Name from ' || v_printer_name_old || ' to ' || p_printer_name || ', ' ||
						'Updated Is In Use from ' || v_is_in_use_old || ' to ' || p_is_in_use || ', ' ||
						'Updated Display Sequence from ' || v_display_seq_old || ' to ' || p_display_seq || ', ' ||
						'Updated Is Default from ' || v_is_default_old || ' to ' || p_is_default || ', ' ||
						'Updated Printer Type ID from ' || v_printer_type_id_old || ' to ' || p_printer_type_id || '.';
			
	END IF;
	
	p_msg := 'ok';
	
	-- Create Audit Log
	CALL pr_sys_append_audit_log (
		p_msg => audit_log
		, p_remarks => 'pr_pos_printer_save'
		, p_uid => p_current_uid
		, p_id1 => p_pos_printer_id
		, p_id2 => null
		, p_id3 => null
        , p_app_id => null
		, p_module_code => module_code
	); 
	
	-- -------------------------------------
	-- cleanup
	-- -------------------------------------
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_pos_printer_save - end';
	END IF;

END
$BODY$;