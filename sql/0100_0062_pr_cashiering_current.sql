CREATE OR REPLACE FUNCTION fn_cashiering_current (
	p_current_uid character varying(255),
	p_cashier_id character varying(255),
	p_tr_date date,
	p_rid integer,
	p_axn character varying(255),
	p_url character varying(255),
	p_is_debug integer DEFAULT 0
) RETURNS TABLE (
	current_shift timestamp without time zone,
	last_shift timestamp without time zone,
	cashier_id character varying(255)
)
LANGUAGE 'plpgsql'
AS $BODY$
-- -------------------------------------
-- init
-- -------------------------------------
DECLARE
	v_curr_shift timestamp;
	v_last_shift timestamp;
	v_tr_date date;
BEGIN
/* 0100_0062_pr_cashiering_current

	SELECT * FROM fn_cashiering_current (
		p_current_uid => 'tester',
		p_cashier_id => null,
		p_tr_date => null,
		p_rid => null,
		p_axn => null,
		p_url => null
	);
	
	SELECT * FROM fn_cashiering_current('tester','','2024-11-22T08:00:00.000+08:00',0,null,null,0)

*/

	IF p_is_debug = 1 THEN
		RAISE NOTICE 'fn_cashiering_current - start';
	END IF;

	-- -------------------------------------
	-- validation
	-- -------------------------------------
	IF p_cashier_id IS NULL THEN 
		p_cashier_id := p_current_uid;
	END IF;
	
	IF p_tr_date IS NULL THEN 
		p_tr_date := fn_get_current_trans_dt();
	END IF;
	
	RAISE NOTICE 'Trans Date: %', p_tr_date;

	-- -------------------------------------
	-- process
	-- -------------------------------------
	SELECT a.start_on, a.tr_date
	INTO v_curr_shift, v_tr_date
	FROM tb_cashiering a
	WHERE
		a.tr_date = p_tr_date
		AND a.cashier_id = p_cashier_id
		AND a.start_on IS NOT NULL
		AND a.end_on IS NULL;
		
	SELECT a.end_on
	INTO v_last_shift a
	FROM tb_cashiering a
	WHERE
		a.tr_date <= p_tr_date
		AND a.cashier_id = p_cashier_id
		AND a.end_on IS NOT NULL
	ORDER BY a.end_on DESC
	LIMIT 1;
	
	-- Return result
	RETURN QUERY (
		SELECT 
			v_curr_shift AS current_shift,
			v_last_shift AS last_shift,
			p_cashier_id AS cashier_id
	);

	-- -------------------------------------
	-- cleanup
	-- -------------------------------------
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'fn_cashiering_current - end';
	END IF;

END
$BODY$;