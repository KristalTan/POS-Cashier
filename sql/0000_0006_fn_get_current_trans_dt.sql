CREATE OR REPLACE FUNCTION fn_get_current_trans_dt ()
RETURNS date
LANGUAGE 'plpgsql'
AS $BODY$
-- -------------------------------------
-- init
-- -------------------------------------
DECLARE
	v_current_dt date;
BEGIN
/*

	SELECT * FROM fn_get_current_trans_dt();

*/

	-- -------------------------------------
	-- validation
	-- -------------------------------------
	
	-- -------------------------------------
	-- process
	-- -------------------------------------
	SELECT sys_setting_value::DATE
	INTO v_current_dt
	FROM tb_sys_setting 
	WHERE sys_setting_title = 'CURRENT_TRANS_DATE';
	
	RETURN v_current_dt;
	
	-- -------------------------------------
	-- cleanup
	-- -------------------------------------

END
$BODY$;