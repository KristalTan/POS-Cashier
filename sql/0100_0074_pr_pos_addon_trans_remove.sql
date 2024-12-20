CREATE OR REPLACE PROCEDURE pr_pos_addon_trans_remove (
	IN p_current_uid character varying(255),
	OUT p_msg text,
	IN p_order_trans_id uuid,
	IN p_order_trans_item_line_id uuid,
	IN p_modifier_option_id uuid,
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
	v_order_trans_modifier_id_old uuid;
BEGIN
/* 0100_0074_pr_pos_addon_trans_remove

	CALL pr_pos_addon_trans_remove (
		p_current_uid => 'tester',
		p_msg => null,
		p_order_trans_id => 'a426559b-c5e4-4e62-8185-44582732107c',
		p_order_trans_item_line_id => '9b3f16b1-c812-46c5-a143-5f449f7372b4',
		p_modifier_option_id => 'dc4320cf-2188-4a9b-9760-abfe8a4c1c67',
		p_rid => null,
		p_axn => null,
		p_url => null
	);

*/

	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_pos_addon_trans_remove - start';
	END IF;
	
	module_code := 'Order - Addon Item Line (Remove)';

	-- -------------------------------------
	-- validation
	-- -------------------------------------
	IF NOT EXISTS (
		SELECT order_trans_item_line_id
		FROM tb_order_trans_item_line
		WHERE order_trans_item_line_id = p_order_trans_item_line_id
	) THEN
		p_msg := 'Invalid Item Line';
		RETURN;
	END IF;
	
	IF fn_to_guid(p_modifier_option_id) = fn_empty_guid() THEN
		p_msg := 'Modifier Option cannot be blank!!';
		RETURN;
	ELSIF NOT EXISTS (
		SELECT 1
		FROM tb_modifier_option
		WHERE modifier_option_id = p_modifier_option_id
	) THEN
		p_msg := 'Invalid Modifier Option!!';
		RETURN;
	END IF;	

	-- -------------------------------------
	-- process
	-- -------------------------------------
	SELECT order_trans_modifier_id
	INTO v_order_trans_modifier_id_old
	FROM tb_order_trans_modifier
	WHERE 
		order_trans_item_line_id = p_order_trans_item_line_id
		AND modifier_option_id = p_modifier_option_id;
	
	DELETE FROM tb_order_trans_modifier
	WHERE 
		order_trans_item_line_id = p_order_trans_item_line_id
		AND modifier_option_id = p_modifier_option_id;
		
	audit_log := 'Remove Modifier: ' || p_modifier_option_id || '.';
	
	p_msg := 'ok';
	
	-- Create Audit Log
	CALL pr_sys_append_audit_log (
		p_msg => audit_log
		, p_remarks => 'pr_pos_addon_trans_remove'
		, p_uid => p_current_uid
		, p_id1 => v_order_trans_modifier_id_old
		, p_id2 => null
		, p_id3 => null
     	, p_app_id => null
		, p_module_code => module_code
	); 

	-- -------------------------------------
	-- cleanup
	-- -------------------------------------
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_pos_addon_trans_remove - end';
	END IF;
	
END
$BODY$;