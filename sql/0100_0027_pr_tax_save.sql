CREATE OR REPLACE PROCEDURE pr_tax_save (
	IN p_current_uid character varying(255),
	OUT p_msg text,
	INOUT p_tax_id uuid,
	IN p_tax_code character varying(255),
	IN p_tax_desc character varying(255),
	IN p_tax_pct numeric(15, 2),
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
	v_tax_code_old character varying(255);
	v_tax_desc_old character varying(255);
	v_tax_pct_old numeric(15, 2);
	v_is_in_use_old integer;
	v_display_seq_old character varying(6);
BEGIN
/* 0100_0027_pr_tax_save

	CALL pr_tax_save(
		p_current_uid => 'tester',
		p_msg => null,
		p_tax_id => '9241fe97-e300-4090-b9d8-6d1c2a6cec9d',
		p_tax_code => 'TEST',
		p_tax_desc => 'Test Charge',
		p_tax_pct => 6,
		p_is_in_use => 1,
		p_display_seq => '000001'
	);
*/

	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_tax_save - start';
	END IF;
	
	module_code := 'Settings - Tax';
	
	-- -------------------------------------
	-- validation
	-- -------------------------------------
	IF LENGTH(COALESCE(p_tax_code, '')) = 0 THEN
		p_msg := 'Tax Code cannot be blank!!';
		RETURN;
	END IF;
	
	IF EXISTS (
		SELECT *
		FROM tb_tax
		WHERE 
			tax_code = p_tax_code
			AND tax_id <> fn_to_guid(p_tax_id)
	) THEN
		p_msg := 'Tax Code: ' || p_tax_code || ' already exists!!';
		RETURN;
	END IF;
	
	IF LENGTH(COALESCE(p_tax_desc, '')) = 0 THEN
		p_msg := 'Tax Description cannot be blank!!';
		RETURN;
	END IF;
	
	IF EXISTS (
		SELECT *
		FROM tb_tax
		WHERE 
			tax_desc = p_tax_desc
			AND tax_id <> fn_to_guid(p_tax_id)
	) THEN
		p_msg := 'Tax Description: ' || p_tax_desc || ' already exists!!';
		RETURN;
	END IF;
	
	-- -------------------------------------
	-- process
	-- -------------------------------------
	IF fn_to_guid(p_tax_id) = fn_empty_guid() THEN
	
		p_tax_id := gen_random_uuid();
		
		-- Insert new record
		INSERT INTO tb_tax (
			tax_id, created_on, created_by, modified_on, modified_by, tax_code, tax_desc, tax_pct, is_in_use, display_seq
		) VALUES (
			p_tax_id, v_now, p_current_uid, v_now, p_current_uid, p_tax_code, p_tax_desc, p_tax_pct, p_is_in_use, p_display_seq
		);
		
		-- Prepare Audit Log
		audit_log := 'Added Tax: ' || p_tax_code || '.';
	
	ELSE
	
		-- Get old record for audit log purpose
		SELECT tax_code, tax_desc, tax_pct, is_in_use, display_seq
		INTO v_tax_code_old, v_tax_desc_old, v_tax_pct_old, v_is_in_use_old, v_display_seq_old
		FROM tb_tax
		WHERE tax_id = p_tax_id;
		
		-- Update record
		UPDATE tb_tax
		SET
			modified_on = v_now,
			modified_by = p_current_uid,
			tax_code = p_tax_code,
			tax_desc = p_tax_desc,
			tax_pct = p_tax_pct,
			is_in_use = p_is_in_use,
			display_seq = p_display_seq
		WHERE tax_id = p_tax_id;
		
		-- Prepare Audit Log
		audit_log = 'Updated Tax Code from ' || v_tax_code_old || ' to ' || p_tax_code || ', ' ||
						'Updated Tax Description from ' || v_tax_desc_old || ' to ' || p_tax_desc || ', ' ||
						'Updated Tax Percentage from ' || v_tax_pct_old || ' to ' || p_tax_pct || ', ' ||
						'Updated Is in Use from ' || v_is_in_use_old || ' to ' || p_is_in_use || ', ' ||
						'Updated Display Sequence from ' || v_display_seq_old || ' to ' || p_display_seq || '.';
						
	END IF;
	
	p_msg := 'ok';
	
	-- Create Audit Log
	CALL pr_sys_append_audit_log (
		p_msg => audit_log
		, p_remarks => 'pr_tax_save'
		, p_uid => p_current_uid
		, p_id1 => p_tax_id
		, p_id2 => null
		, p_id3 => null
        , p_app_id => null
		, p_module_code => module_code
	);
	
	-- -------------------------------------
	-- cleanup
	-- -------------------------------------
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_tax_save - end';
	END IF;

END
$BODY$;