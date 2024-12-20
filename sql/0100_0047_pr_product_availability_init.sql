CREATE OR REPLACE PROCEDURE pr_product_availability_init (
	IN p_current_uid character varying(255), 
	OUT p_msg text, 
	IN p_start_dt date,
	IN p_end_dt date,
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
	current_dt date;
	product_record record;
BEGIN
/* 0100_0047_pr_product_availability_init
	
	CALL pr_product_availability_init (
		p_current_uid => 'tester', 
		p_msg => null, 
		p_start_dt => '2024-12-04',
		p_end_dt => '2024-12-31',
		p_rid => null,
		p_axn => null,
		p_url => null
	);
	
*/
	
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_product_availability_init - start';
	END IF;
	
	module_code := 'Product - Daily Availability';
	
	-- -------------------------------------
	-- validation
	-- -------------------------------------
	IF p_start_dt < fn_get_current_trans_dt() THEN
		p_msg := 'Cannot set past date availability!!';
		RETURN;
	END IF;
	
	IF p_end_dt < p_start_dt THEN
		p_msg := 'Invalid Date Range!!';
		RETURN;
	END IF;
	
	-- -------------------------------------
	-- create temp table
	-- -------------------------------------
	CREATE TEMPORARY TABLE prod_tb (
		product_id uuid
	);
	
	INSERT INTO prod_tb (product_id)
	SELECT product_id
	FROM tb_product 
	WHERE is_in_use = 1;
	
	current_dt := p_start_dt;
	
	-- -------------------------------------
	-- process
	-- -------------------------------------
	WHILE current_dt <= p_end_dt LOOP
        FOR product_record IN 
            SELECT product_id FROM prod_tb 
        LOOP
            INSERT INTO tb_product_availability (
                product_id, 
                created_on, 
                created_by, 
                modified_on, 
                modified_by, 
                dt, 
                qty, 
                sold, 
                is_block, 
                dow, 
                is_weekend
            )
            VALUES (
                product_record.product_id, 
                v_now, 
                p_current_uid, 
                v_now, 
                p_current_uid, 
                current_dt, 
                0, -- Initial quantity
                0, -- Initial sold amount
                0, -- Initial is_block
                EXTRACT(DOW FROM current_dt), -- Day of the week
                CASE WHEN EXTRACT(DOW FROM current_dt) IN (0, 6) THEN 1 ELSE 0 END -- Is weekend
            );
        END LOOP;

        current_dt := current_dt + INTERVAL '1 day'; -- Move to the next day
    END LOOP;
	
	audit_log := 'Initail Product Availability From ' || p_start_dt::text || ' to ' || p_end_dt::text || '.';
	
	p_msg := 'ok';
	
	-- Create Audit Log
	CALL pr_sys_append_audit_log (
		p_msg => audit_log
		, p_remarks => 'pr_product_availability_init'
		, p_uid => p_current_uid
		, p_id1 => null
		, p_id2 => null
		, p_id3 => null
        , p_app_id => null
		, p_module_code => module_code
	); 
	
	-- -------------------------------------
	-- cleanup
	-- -------------------------------------
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_product_availability_init - end';
	END IF;
	
	DROP TABLE prod_tb;

END
$BODY$;