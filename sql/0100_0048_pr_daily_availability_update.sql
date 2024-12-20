CREATE OR REPLACE PROCEDURE pr_daily_availability_update (
	IN p_current_uid character varying(255),
	OUT p_msg text,
	IN p_start_dt date,
	IN p_end_dt date,
	IN p_product_id uuid,
	IN p_qty integer,
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
	v_qty_old integer;
BEGIN
/* 0100_0048_pr_daily_availability_update 
	
	CALL pr_daily_availability_update (
		p_current_uid => 'tester',
		p_msg => null,
		p_start_dt => '2024-12-04',
		p_end_dt => '2024-12-31',
		p_product_id => '2511994e-12d5-488d-9a9b-8c7a49621903',
		p_qty => 10,
		p_rid => null,
		p_axn => null,
		p_url => null
	);
	
*/

	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_daily_availability_update - start';
	END IF;
	
	module_code := 'Product - Daily Availability';
	
	-- -------------------------------------
	-- validation
	-- -------------------------------------
	
	IF p_start_dt IS NULL AND p_end_dt IS NULL THEN
	
		p_start_dt := fn_get_current_trans_dt();
		p_end_dt := p_start_dt + INTERVAL '6 days'; -- SQL DATEADD Function
	
	END IF; 
	
	IF p_start_dt < fn_get_current_trans_dt() THEN
		p_msg := 'Cannot set past date availability!!';
		RETURN;
	END IF;
	
	IF p_end_dt < p_start_dt THEN
		p_msg := 'Invalid Date Range!!';
		RETURN;
	END IF;
	
	IF NOT EXISTS (
		SELECT product_id 
		FROM tb_product 
		WHERE product_id = p_product_id
	) THEN
		p_msg := 'Invalid Product!!';
		RETURN;
	END IF;
	
	-- -------------------------------------
	-- process
	-- -------------------------------------
	
	-- Get old record for audit log
	SELECT qty
	INTO v_qty_old
	FROM tb_product_availability
	WHERE product_id = p_product_id;
	
	-- Update the availability by using remaining qty + new adding qty
	IF EXISTS (
		SELECT product_id
		FROM tb_product_availability
		WHERE 
			dt between p_start_dt and p_end_dt
	) THEN
	
		UPDATE tb_product_availability
		SET qty = COALESCE(v_qty_old, 0) + p_qty
		WHERE product_id = p_product_id;
		
	ELSE
	
		p_msg := 'System cannot find the record!!';
		RETURN;
	
	END IF;
	
	audit_log := 'Update product: ' || p_product_id || ' daily availability from ' || COALESCE(v_qty_old, 0)::text ||  ' to ' || (COALESCE(v_qty_old, 0) + p_qty)::text || '.';
	
	p_msg := 'ok';
	
	-- Create Audit Log
	CALL pr_sys_append_audit_log (
		p_msg => audit_log
		, p_remarks => 'pr_product_availability_update'
		, p_uid => p_current_uid
		, p_id1 => p_product_id
		, p_id2 => null
		, p_id3 => null
        , p_app_id => null
		, p_module_code => module_code
	); 
	
	-- -------------------------------------
	-- cleanup
	-- -------------------------------------
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_daily_availability_update - end';
	END IF;

END
$BODY$;