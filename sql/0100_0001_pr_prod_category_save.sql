CREATE OR REPLACE PROCEDURE pr_prod_category_save (
	IN p_current_uid character varying(255),
	OUT p_msg character varying(255),
	INOUT p_category_id uuid,
	IN p_category_desc character varying(255),
	IN p_is_in_use integer,
	IN p_display_seq character varying(255),
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
	v_category_desc_old character varying(255);
	v_is_in_use_old integer;
	v_display_seq_old character varying(255);
BEGIN
/* 0100_0001_pr_prod_category_save
	
	CALL pr_prod_category_save (
		p_current_uid => 'tester',
		p_msg => null,
		p_category_id => null,
		p_category_desc => 'Appetizers',
		p_is_in_use => 1,
		p_display_seq => '000001'
	);
*/

	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_prod_catgeory_save - start';
	END IF;
	
	module_code := 'Product Category';
	
	-- -------------------------------------
	-- validation
	-- -------------------------------------
	IF LENGTH(COALESCE(p_category_desc, '')) = 0 THEN 
		p_msg := 'Category Description cannot be blank!!';
		RETURN;
	END IF;
	
	IF EXISTS (
		SELECT *
		FROM tb_prod_category
		WHERE 
			category_desc = p_category_desc
			AND category_id <> fn_to_guid(p_category_id)
	) THEN
		p_msg := 'Category: ' || p_category_desc || ' already exists!!';
		RETURN;
	END IF;
	
	-- -------------------------------------
	-- process
	-- -------------------------------------
	IF fn_to_guid(p_category_id) = fn_empty_guid() THEN
	
		p_category_id := gen_random_uuid();
		
		-- Insert new record
		INSERT INTO tb_prod_category (
			category_id, created_on, created_by, modified_on, modified_by, category_desc,
			is_in_use, display_seq
		) VALUES (
			p_category_id, v_now, p_current_uid, v_now, p_current_uid, p_category_desc,
			COALESCE(p_is_in_use, 0), p_display_seq
		);
		
		-- Prepare Audit Log
		audit_log := 'Added Product Category: ' || p_category_desc || '.';
	
	ELSE
	
		-- Get old record foro audiit log purpose
		SELECT category_desc,is_in_use, display_seq
		INTO v_category_desc_old, v_is_in_use_old, v_display_seq_old
		FROM tb_prod_category
		WHERE category_id = p_category_id;
		
		-- Update record
		UPDATE tb_prod_category
		SET
			modified_on = v_now,
			modified_by = p_current_uid,
			category_desc = p_category_desc,
			is_in_use = COALESCE(p_is_in_use, 0),
			display_seq = p_display_seq
		WHERE category_id = p_category_id;
		
		-- Prepare Audit Log
		audit_log := 'Updated Category Description from ' || v_category_desc_old || ' to ' || p_category_desc || ', ' ||
						'Updated Is in Use from ' || v_is_in_use_old || ' to ' || p_is_in_use || ', ' ||
						'Updated Display Sequence from ' || v_display_seq_old || ' to ' || p_display_seq || '.';

	END IF;
	
	p_msg := 'ok';
	
	-- Create Audit Log
	CALL pr_sys_append_audit_log (
		p_msg => audit_log
		, p_remarks => 'pr_prod_category_save'
		, p_uid => p_current_uid
		, p_id1 => p_category_id
		, p_id2 => null
		, p_id3 => null
        , p_app_id => null
		, p_module_code => module_code
	); 
	
	-- -------------------------------------
	-- cleanup
	-- -------------------------------------
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_prod_catgeory_save - end';
	END IF;
	
END
$BODY$;