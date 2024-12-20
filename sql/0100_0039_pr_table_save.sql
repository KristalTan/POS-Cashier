CREATE OR REPLACE PROCEDURE pr_table_save (
	IN p_current_uid character varying(255),
	OUT p_msg text,
	INOUT p_table_id uuid,
	IN p_table_desc character varying(255),
	IN p_table_section_id uuid,
	IN p_qr_code text,
	IN p_is_in_use integer,
	IN p_display_seq character varying(6),
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
	v_now CONSTANT timestamp = localtimestamp;
	audit_log text;
	module_code text;
	v_table_desc_old character varying(255);
	v_table_section_id_old uuid;
	v_qr_code_old text;
	v_is_in_use_old integer;
	v_display_seq_old character varying(6);
	v_order_msg text;
BEGIN
/* 0100_0039_pr_table_save

	CALL pr_table_save (
		p_current_uid => 'tester',
		p_msg => null,
		p_table_id => null,
		p_table_desc => 'T-02',
		p_table_section_id => '81d41970-33b6-43dd-9e93-fd091bfcc2a3',
		p_qr_code => null,
		p_is_in_use => 1,
		p_display_seq => '000002',
		p_rid => null,
		p_axn => null,
		p_url => null
	);

*/
	
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_table_save - start';
	END IF;
	
	module_code := 'Setting - Table';
	
	-- -------------------------------------
	-- validation
	-- -------------------------------------

	
	IF LENGTH(COALESCE(p_table_desc, '')) = 0 THEN
		p_msg := 'Table Name cannot be blank!!';
		RETURN;
	END IF;
	
	IF EXISTS (
		SELECT *
		FROM tb_table
		WHERE 
			table_desc = p_table_desc
			AND table_id <> fn_to_guid(p_table_id)
	) THEN
		p_msg := 'Table Name: ' || p_table_desc || ' already exists!!';
		RETURN;
	END IF;
	
	IF NOT EXISTS (
		SELECT *
		FROM tb_table_section
		WHERE table_section_id = p_table_section_id
	) THEN
		p_msg := 'Invalid Table Section!!';
		RETURN;
	END IF;


	
	-- -------------------------------------
	-- process
	-- -------------------------------------
	IF fn_to_guid(p_table_id) = fn_empty_guid() THEN
		
		p_table_id := gen_random_uuid();
		
		-- Insert new record
		INSERT INTO tb_table (
			table_id, created_on, created_by, modified_on, modified_by, table_desc, table_section_id, qr_code, is_in_use, display_seq
		) VALUES (
			p_table_id, v_now, p_current_uid, v_now, p_current_uid, p_table_desc, p_table_section_id, p_qr_code, p_is_in_use, p_display_seq
		);
		
		-- Prepare Audit Log
		audit_log := 'Added Table: ' || p_table_desc || '.';
		
	ELSE
	
		-- Get old record for audit log purpose
		SELECT table_desc, table_section_id, qr_code, is_in_use, display_seq
		INTO v_table_desc_old, v_table_section_id_old, v_qr_code_old, v_is_in_use_old, v_display_seq_old
		FROM tb_table
		WHERE table_id = p_table_id;
		
		-- Update record
		UPDATE tb_table
		SET
			modified_on = v_now,
			modified_by = p_current_uid,
			table_desc = p_table_desc,
			table_section_id = p_table_section_id,
			qr_code = p_qr_code,
			is_in_use = p_is_in_use,
			display_seq = p_display_seq
		WHERE table_id = p_table_id;
		
		-- Prepare Audit Log
		audit_log := 'Updated Table Name from ' || v_table_desc_old || ' to ' || p_table_desc || ', ' ||
						'Updated Table Section from ' || v_table_section_id_old || ' to ' || p_table_section_id || ', ' ||
						'Updated QR Code from ' || v_qr_code_old || ' to ' || p_qr_code || ', ' ||
						'Updated Is In Use from ' || v_is_in_use_old || ' to ' || p_is_in_use || ', ' ||
						'Updated Display Sequence from ' || v_display_seq_old || ' to ' || p_display_seq || '.';

	END IF;
	
	p_msg := 'ok';
	
	-- Create Audit Log
	CALL pr_sys_append_audit_log (
		p_msg => audit_log
		, p_remarks => 'pr_table_save'
		, p_uid => p_current_uid
		, p_id1 => p_table_id
		, p_id2 => null
		, p_id3 => null
        , p_app_id => null
		, p_module_code => module_code
	);
	
	-- Save Order Trans Table Status
	CALL pr_order_trans_table_init (
		p_current_uid => p_current_uid,
		p_msg => v_order_msg,
		p_table_id => p_table_id,
		p_table_desc => p_table_desc
	);
	
	IF v_order_msg <> 'ok' THEN
		p_msg := v_order_msg;
		RETURN;
	END IF;
	
	-- -------------------------------------
	-- cleanup
	-- -------------------------------------
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_table_save - end';
	END IF;

END
$BODY$;