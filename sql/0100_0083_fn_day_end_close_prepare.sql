CREATE OR REPLACE FUNCTION fn_day_end_close_prepare (
	p_current_uid character varying(255),
	p_curr_tr_dt date,
	p_rid integer,
	p_axn character varying(255),
	p_url character varying(255),
	p_is_debug integer DEFAULT 0
) RETURNS TABLE (
	seq integer,
	can_close integer,
	msg text,
	solution text,
	acn text
)
LANGUAGE 'plpgsql'
AS $$
-- -------------------------------------
-- init
-- -------------------------------------
DECLARE
	doc_no_record text;
	r text;
	csh1 integer;
	csh2 integer;
	csh record;
BEGIN
/*

	SELECT * FROM fn_day_end_close_prepare (
		'tester',
		null,
		null,
		null,
		null
	);	

*/

	CREATE TEMPORARY TABLE close_check(
		seq serial,
		can_close integer,
		msg text,
		solution text,
		acn text
	);

	-- -------------------------------------
	-- validation
	-- -------------------------------------
	IF p_curr_tr_dt IS NULL THEN
		p_curr_tr_dt = fn_get_current_trans_dt();
	END IF;

	-- -------------------------------------
	-- process
	-- -------------------------------------
    -- Checking the pending order transaction
    FOR doc_no_record IN
        SELECT a.doc_no
        FROM tb_order_trans a
        WHERE a.tr_date = p_curr_tr_dt
          AND a.tr_status = 'C'
          AND round(a.outstanding_amt, 2) <> 0
    LOOP

         -- Only add a comma if 's' is not empty
        IF r = '' THEN
            r := doc_no_record;
        ELSE
            r := r || ', ' || doc_no_record;
        END IF;
    END LOOP;
	
	IF LENGTH(COALESCE(r, '')) = 0 THEN
		
		INSERT INTO close_check (can_close, msg) VALUES 
		(1, 'All Order Transaction has been done.');
		
	ELSE 
		
		INSERT INTO close_check (can_close, msg, solution) VALUES 
		(0, 'Kindly process the payment for this/these order #: ' || r, 'Please verify that all orders have been paid before performing the day-end tasks.');
	
	END IF;
	
	-- Checking cashiering
	SELECT COUNT(*)
	INTO csh1
	FROM tb_cashiering
	WHERE tr_date = p_curr_tr_dt;
	
	SELECT COUNT(*)
	INTO csh2
	FROM tb_cashiering
	WHERE 
		tr_date = p_curr_tr_dt
		AND end_on IS NULL;
		
	IF csh2 = 0 THEN
	
		INSERT INTO close_check (can_close, msg) VALUES
		(1, 'All cashiering shifts have been closed (' || csh1::text || '/' || csh1::text || ').');
	
	ELSE
	
		FOR csh IN
        SELECT a.cashier_id, a.start_on, a.end_on
        FROM tb_cashiering a
        WHERE 
			a.tr_date = p_curr_tr_dt
          	AND a.end_on IS NULL
        
		LOOP

			 -- Only add a comma if 's' is not empty
			IF csh = '' THEN
				csh := csh.cashier_id || ' - ' || 'Shift Start on: ' || csh.start_on || ', ' || 'Shift end on: ' || csh.end_on ;
			ELSE
				csh := csh || ', ' || csh.cashier_id || ' - ' || 'Shift Start on: ' || csh.start_on || ', ' || 'Shift end on: ' || csh.end_on ;
			END IF;
		END LOOP;
		
		INSERT INTO close_check (can_close, msg, solution, acn) VALUES
		(0, 'Total Cashiering Shift: ' || csh1::text || ', ' || 'Total Unclose Cashiering Shift: ' || csh2::text, 
		'Kindly confirm that all cashiering shifts are closed before proceeding with the day-end process.',
		'app-cashiering-shift::fc'
		);
	
	END IF;
	
	RETURN QUERY (
		SELECT *
		FROM close_check
		ORDER BY seq
	);
	
	-- -------------------------------------
	-- cleanup
	-- -------------------------------------
END
$$;