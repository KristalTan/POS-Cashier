CREATE OR REPLACE PROCEDURE pr_meal_period_delete(
	IN p_current_uid character varying(255),
	OUT p_msg text,
	INOUT p_meal_period_id uuid,
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
	v_meal_period_desc_old character varying(255);
BEGIN
/* 0100_0006_pr_meal_period_delete

*/

	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_meal_period_delete - start';
	END IF;
	
	module_code := 'Settings - Meal Period';
	
	-- -------------------------------------
	-- validation
	-- -------------------------------------
	IF NOT EXISTS (
		SELECT *
		FROM tb_meal_period
		WHERE meal_period_id = p_meal_period_id
	) THEN
		p_msg := 'Meal Period is not exists!!';
		RETURN;
	END IF;
	
	IF EXISTS (
		SELECT * 
		FROM tb_food_menu
		WHERE meal_period_id = p_meal_period_id
	) THEN
		p_msg := 'Deletion is not allowed because the record in use in Food Menu!!';
		RETURN;
	END IF;
	
	-- -------------------------------------
	-- process
	-- -------------------------------------
	
	-- Get old record for audit log purpose
	SELECT meal_period_desc
	INTO v_meal_period_desc_old 
	FROM tb_meal_period
	WHERE meal_period_id = p_meal_period_id;
	
	-- Delete record
	DELETE FROM tb_meal_period
	WHERE meal_period_id = p_meal_period_id;
	
	-- Prepare Audit Log
	audit_log := 'Deleted Meal Period: ' || v_meal_period_desc_old || '.';
	
	p_msg := 'ok';
	
	-- Create Audit Log
	CALL pr_sys_append_audit_log (
		p_msg => audit_log
		, p_remarks => 'pr_meal_period_delete'
		, p_uid => p_current_uid
		, p_id1 => p_meal_period_id
		, p_id2 => null
		, p_id3 => null
        , p_app_id => null
		, p_module_code => module_code
	);
	
	-- -------------------------------------
	-- cleanup
	-- -------------------------------------
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_meal_period_delete - end';
	END IF;

END
$BODY$;