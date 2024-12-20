CREATE OR REPLACE PROCEDURE pr_pos_trans_bill_disc (
	IN p_current_uid character varying(255),
	OUT p_msg text,
	IN p_order_trans_id uuid,
	IN p_bill_discount_id uuid,
	IN p_bill_discount_pct numeric(15, 2),
	IN p_bill_discount_amt numeric(15, 2),
	IN p_override_by character varying(255),
	IN p_override_remarks text,
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
	v_order_trans_id uuid;
	v_tr_type character varying(50);
	v_tr_status character varying(50);
	v_tr_date date;
	v_qty integer;
	v_cost_old numeric(15, 4);
	v_amt_old numeric(15,4);
	v_tax_code1 character varying(255);
	v_tax_code2 character varying(255);
	v_amt_include_tax1 integer;
	v_amt_include_tax2 integer;
	v_calc_tax2_after_tax1 integer;
	v_order_trans_item_line_id uuid;
	v_product_id uuid;
	v_doc_no character varying(50);
	v_disc_amt numeric(15, 4);
	v_sell_amt_new numeric(15, 4);
	v_amt numeric(15, 4);
	v_unit_price_new numeric(15, 4);
	v_tax_pct1 numeric(15, 2);
	v_tax_pct2 numeric(15, 2);
	v_tax_amt1_calc numeric(15, 4);
	v_tax_amt2_calc numeric(15, 4);
	v_total_amt numeric(15, 2);
	v_msg text;
	v_now CONSTANT timestamp = current_timestamp;
	audit_log text;
	module_code text;
BEGIN
/* 0100_0052_pr_pos_trans_bill_disc
	
-- 	BEGIN;
		CALL pr_pos_trans_bill_disc (
			p_current_uid => 'tester',
			p_msg => null,
			p_order_trans_id => '1c3759e2-04f9-4ec4-a234-d17ae53e1866',
			p_bill_discount_id => null,
			p_bill_discount_pct => 50,
			p_bill_discount_amt => null,
			p_override_by => 'tester',
			p_override_remarks => 'testing',
			p_rid => null,
			p_axn => '',
			p_url => ''
		);
		
		select * from tb_order_trans_item_line where order_trans_id = '1c3759e2-04f9-4ec4-a234-d17ae53e1866';
-- 	ROLLBACK;

*/

	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_pos_trans_bill_disc - start';
	END IF;
	
	module_code := 'Order - Bill Discount';
	
	-- CREATE TEMP TABLE
	CREATE TEMPORARY TABLE item_line_tb (
		order_trans_id uuid,
		tr_status character varying(50),
		tr_type character varying(50),
		tr_date date,
		qty integer,
		cost numeric(15, 4),
		amt numeric(15, 4),
		tax_code1 character varying(255),
		tax_code2 character varying(255),
		amt_include_tax1 integer,
		amt_include_tax2 integer,
		calc_tax2_after_tax1 integer,
		order_trans_item_line_id uuid,
		product_id uuid,
		doc_no character varying(50)
	);

	-- -------------------------------------
	-- validation
	-- -------------------------------------
	IF fn_to_guid(p_order_trans_id) = fn_empty_guid()
	OR NOT EXISTS (
		SELECT order_trans_id
		FROM tb_order_trans
		WHERE order_trans_id = p_order_trans_id
	) THEN
		p_msg := 'Invalid Bill!!';
		RETURN;
	END IF;
	
	IF EXISTS (
		SELECT tr_status
		FROM tb_order_trans
		WHERE 
			order_trans_id = p_order_trans_id
			AND tr_status = 'X'
	) THEN
		p_msg := 'Cannot Do Discount due to the bill already been cancelled!!';
		RETURN;
	END IF;
	
	IF p_bill_discount_pct <= 0 AND COALESCE(p_bill_discount_amt, NULL::numeric) IS NULL THEN
		p_msg := 'Discount percent must greater than 0!!';
		RETURN;
	END IF;
	
	IF p_bill_discount_amt <= 0 AND COALESCE(p_bill_discount_pct, NULL::numeric) IS NULL THEN
		p_msg := 'Discount amount must greater than 0!!';
		RETURN;
	END IF;
	
	IF LENGTH(COALESCE(p_override_by, '')) = 0 THEN
		p_override_by := p_current_uid;
	END IF;
	
	SELECT amt
	INTO v_total_amt 
	FROM tb_order_trans
	WHERE order_trans_id = p_order_trans_id;
	
	IF (v_total_amt - p_bill_discount_amt) < 0 THEN
		p_msg := 'Discount amount cannot greater than bill price!!';
		RETURN;
	END IF;

	-- -------------------------------------
	-- process
	-- -------------------------------------
	INSERT INTO item_line_tb (
		order_trans_id, tr_status, tr_type, tr_date, qty, 
		cost, amt, tax_code1, tax_code2, 
		amt_include_tax1, amt_include_tax2, calc_tax2_after_tax1, 
		order_trans_item_line_id, product_id, doc_no
	)
	SELECT 
		a.order_trans_id, a.tr_status, a.tr_type, a.tr_date, a.qty,
		b.cost, a.amt, b.tax_code1, b.tax_code2,
		b.amt_include_tax1, b.amt_include_tax2, b.calc_tax2_after_tax1,
		a.order_trans_item_line_id, a.product_id, a.doc_no
	FROM tb_order_trans_item_line a
	INNER JOIN tb_product b ON b.product_id = a.product_id
	WHERE order_trans_id = p_order_trans_id;
	
	WHILE (SELECT COUNT(DISTINCT order_trans_item_line_id) FROM item_line_tb) > 0 LOOP
		
		SELECT 
			order_trans_id, tr_status, tr_type, tr_date, qty, cost,	amt, tax_code1, tax_code2, amt_include_tax1, amt_include_tax2, calc_tax2_after_tax1, 
			order_trans_item_line_id, product_id, doc_no
		INTO 
			v_order_trans_id, v_tr_status, v_tr_type, v_tr_date, v_qty, v_cost_old, v_amt_old, v_tax_code1, v_tax_code2, v_amt_include_tax1, v_amt_include_tax2, 
			v_calc_tax2_after_tax1, v_order_trans_item_line_id, v_product_id, v_doc_no
		FROM item_line_tb 
		LIMIT 1;
		
		-- Calculate discount based on the provided input (either percentage or fixed amount)
		v_disc_amt := CASE 
						WHEN p_bill_discount_pct > 0 THEN COALESCE(v_amt_old, 0) * COALESCE(p_bill_discount_pct, 0) / 100
						WHEN p_bill_discount_amt > 0 THEN v_amt_old * p_bill_discount_amt / v_total_amt
						ELSE 0
					END;
		
		v_sell_amt_new := CASE 
							WHEN p_bill_discount_pct > 0 THEN v_amt_old * (1 - p_bill_discount_pct / 100)
							WHEN p_bill_discount_amt > 0 THEN v_amt_old * (1 - p_bill_discount_amt / v_total_amt)
							ELSE 0
						END;
		RAISE NOTICE 'Discount Amt: %, Sell Amt New: %', v_disc_amt, v_sell_amt_new;
		
		SELECT final_price, unit_price, tax_pct1, tax_amt1_calc, tax_pct2, tax_amt2_calc
		INTO v_amt, v_unit_price_new, v_tax_pct1, v_tax_amt1_calc, v_tax_pct2, v_tax_amt2_calc
		FROM fn_tax_calculation (
			p_tax_code1 => v_tax_code1,
			p_tax_code2 => v_tax_code2,
			p_amt_include_tax1 => v_amt_include_tax1,
			p_amt_include_tax2 => v_amt_include_tax2,
			p_calc_tax2_after_tax1 => v_calc_tax2_after_tax1,
			p_qty => v_qty,
			p_amt => v_sell_amt_new
		);
		
		RAISE NOTICE 'Discount Pct: %, Discount Amt: %, Sell Price New: %, Final Price: %, Unit Price: %', p_bill_discount_pct, p_bill_discount_amt, v_sell_amt_new, v_amt, v_unit_price_new;
		
		UPDATE tb_order_trans_item_line
		SET 
			discount_id = p_bill_discount_id,
			discount_amt = p_bill_discount_amt,
			discount_pct = p_bill_discount_pct,
			total_disc_amt = v_disc_amt,

			sell_price = v_unit_price_new,
			amt = v_amt,

			tax_code1 = v_tax_code1,
			tax_pct1 = v_tax_pct1,
			tax_amt1_calc = v_tax_amt1_calc,
			tax_code2 = v_tax_code2,
			tax_pct2 = v_tax_pct2,
			tax_amt2_calc = v_tax_amt2_calc,

			price_override_on = v_now,
			price_override_by = p_override_by,
			remarks = p_override_remarks
		WHERE order_trans_item_line_id = v_order_trans_item_line_id;
			
		-- Clear
		DELETE FROM item_line_tb 
		WHERE order_trans_item_line_id = v_order_trans_item_line_id;
		
	END LOOP;
	
	CALL pr_order_trans_refresh (
		p_current_uid => p_current_uid,
		p_msg => v_msg,
		p_order_trans_id => p_order_trans_id,
		p_doc_no => v_doc_no,
		p_tr_status => v_tr_status
	);
	
	IF v_msg <> 'ok' THEN 
		p_msg := 'Error happen in process!!';
		RETURN;
	END IF;
	
	p_msg := 'ok';
	
	-- Create Audit Log
	CALL pr_sys_append_audit_log (
		p_msg => audit_log
		, p_remarks => 'pr_pos_trans_bill_disc'
		, p_uid => p_current_uid
		, p_id1 => p_order_trans_id
		, p_id2 => null
		, p_id3 => null
     	, p_app_id => null
		, p_module_code => module_code
	); 

	-- -------------------------------------
	-- cleanup
	-- -------------------------------------
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_pos_trans_bill_disc - end';
	END IF;
	
	DROP TABLE item_line_tb;

END
$BODY$;