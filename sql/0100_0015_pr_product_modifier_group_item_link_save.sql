CREATE OR REPLACE PROCEDURE pr_product_modifier_group_item_link_save (
	IN p_current_uid character varying(255),
	OUT p_msg text,
	IN p_link_item text,
	IN p_modifier_group_id uuid,
	IN p_rid integer,
	IN p_axn character varying(255),
	IN p_url character varying(255),
	IN p_is_debug integer DEFAULT 0
)
language 'plpgsql'
AS $BODY$
-- -------------------------------------
-- init
-- -------------------------------------
DECLARE
	v_now CONSTANT timestamp = localtimestamp;
	audit_log text;
	module_code text;
	product_record RECORD;  -- Define product_record as a RECORD type
BEGIN
/*

	CALL pr_product_modifier_group_item_link_save (
		p_current_uid => 'tester',
		p_msg => null,
		p_link_item => '77e1b5fb-c40b-4e0c-8638-7b807589fa37;;2261de06-f946-41ac-b787-929c1d67c60f;;17ea1fb4-c3ef-4bad-ae51-bf51932e3752',
		p_modifier_group_id => '00b3a893-a452-4d72-9f89-2868683c2834'
	);

*/
	
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_product_modifier_group_item_link_save - start';
	END IF;
	
	module_code := 'Settings - Modifier Group Item Link';
	
	-- -------------------------------------
	-- validation
	-- -------------------------------------
	IF NOT EXISTS (
		SELECT modifier_group_id
		FROM tb_modifier_group
		WHERE modifier_group_id = p_modifier_group_id
	) THEN
		p_msg := 'Invalid Modifier Group';
		RETURN;
	END IF;
	
	-- -------------------------------------
    -- create and use temporary table
    -- -------------------------------------
    CREATE TEMPORARY TABLE prod_tb (
        p_product_id uuid
    );
	
	INSERT INTO prod_tb (p_product_id)
	SELECT 
		CAST(TRIM(value) AS uuid)
	FROM unnest(string_to_array(p_link_item, ';;')) AS value
	WHERE TRIM(value) IS NOT NULL AND TRIM(value) <> '';
	
	FOR product_record IN SELECT p_product_id FROM prod_tb LOOP
		-- Check if the product_id exists in tb_product
		IF NOT EXISTS (
			SELECT 1
			FROM tb_product a
			WHERE a.product_id = product_record.p_product_id
		) THEN
			p_msg := 'Invalid Product!!';
			RETURN;
		END IF;
		
		IF NOT EXISTS (
			SELECT 1
			FROM tb_product a
			WHERE 
				a.product_id = product_record.p_product_id
				AND a.is_allow_modifier = 1
		) THEN
			p_msg := 'The Product not allow modifier set up!!';
			RETURN;
		END IF;
	END LOOP;

	-- -------------------------------------
	-- process
	-- -------------------------------------
	IF NOT EXISTS (
		SELECT modifier_group_id 
		FROM tb_modifier_item_link
		WHERE modifier_group_id = p_modifier_group_id
	) THEN 
	
		FOR product_record IN SELECT p_product_id FROM prod_tb LOOP

			INSERT INTO tb_modifier_item_link (
				modifier_item_link_id, created_on, created_by, modified_on, modified_by, modifier_group_id, product_id
			) VALUES (
				gen_random_uuid(), v_now, p_current_uid, v_now, p_current_uid, p_modifier_group_id, product_record.p_product_id
			);

		END LOOP;
		
		audit_log := 'Added product link: ' || product_record.p_product_id || '.';
		
	ELSE 
	
		DELETE FROM tb_modifier_item_link WHERE modifier_group_id = p_modifier_group_id;
		
		FOR product_record IN SELECT p_product_id FROM prod_tb LOOP

			INSERT INTO tb_modifier_item_link (
				modifier_item_link_id, created_on, created_by, modified_on, modified_by, modifier_group_id, product_id
			) VALUES (
				gen_random_uuid(), v_now, p_current_uid, v_now, p_current_uid, p_modifier_group_id, product_record.p_product_id
			);

		END LOOP;
		
		audit_log := 'Updated product link: ' || product_record.p_product_id || '.';
	
	END IF;
	
	p_msg := 'ok';
	
	-- Create Audit Log
	CALL pr_sys_append_audit_log (
		p_msg => audit_log
		, p_remarks => 'pr_product_modifier_group_item_link_save'
		, p_uid => p_current_uid
		, p_id1 => p_modifier_group_id
		, p_id2 => null
		, p_id3 => null
        , p_app_id => null
		, p_module_code => module_code
	);

	-- -------------------------------------
	-- cleanup
	-- -------------------------------------
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_product_modifier_group_item_link_save - end';
	END IF;
	
	DROP TABLE prod_tb;

END
$BODY$;