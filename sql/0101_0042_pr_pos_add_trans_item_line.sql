CREATE OR REPLACE PROCEDURE pr_pos_add_trans_item_line (
	IN p_current_uid character varying(255),
	--IN p_sess_id uuid,
	OUT p_msg text,
	INOUT p_order_trans_item_line_id uuid,
	IN p_tr_date date,
	IN p_tr_type character varying(50),
	IN p_tr_status character varying(50),
	IN p_order_trans_id uuid,
	IN p_doc_no character varying(255),
	IN p_product_id uuid,
	IN p_cost numeric(15, 4),
	IN p_sell_price numeric(15, 4),
	IN p_addon_amt numeric(15, 4),
	IN p_amt numeric(15, 4),
	IN p_qty integer,
	IN p_discount_id uuid,
	IN p_discount_amt numeric(15, 4),
	IN p_discount_pct numeric(15, 4),
	IN p_total_disc_amt numeric(15, 4),
	IN p_is_pymt integer,
	IN p_pymt_mode_id uuid,
	IN p_ref_no character varying(255),
	IN p_remarks character varying(255), 
	IN p_coupon_no character varying(255),
	IN p_coupon_id uuid,
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
	v_tax_code1 character varying(255);
	v_tax_pct1 numeric(15, 4);
	v_amt_include_tax1 integer;
	v_tax_amt1_calc numeric(15, 4);
	v_tax_code2 character varying(255);
	v_tax_pct2 numeric(15, 4);
	v_amt_include_tax2 integer;
	v_calc_tax2_after_tax1 integer;
	v_tax_amt2_calc numeric(15, 4);
	v_cost numeric(15, 4);
	v_seq integer;
	v_new_amt numeric(15, 4);
	v_new_sell_price numeric(15, 4);
	v_now CONSTANT timestamp = current_timestamp;
	v_today_dt CONSTANT date = current_date;
	
	-- Update get old record
	v_tr_date_old date;
	v_tr_type_old character varying(50);
	v_tr_status_old character varying(50);
	v_doc_no_old character varying(50);
	v_product_id_old uuid;
	v_qty_old integer;
	v_cost_old numeric(15, 4);
	v_sell_price_old numeric(15, 4); 
	v_seq_old integer;
	v_order_trans_id_old uuid;
	v_discount_id_old uuid;
	v_discount_amt_old numeric(15, 2);
	v_discount_pct_old numeric(15, 2); 
	v_total_disc_amt_old numeric(15, 4); 
	v_is_pymt_old integer;
	v_pymt_mode_id_old uuid;
	v_ref_no_old character varying(255);
	v_remarks_old character varying(255);
	v_amt_old numeric(15, 2); 
	v_price_override_on_old timestamp;
	v_price_override_by_old character varying(255);
	v_coupon_no_old character varying(50);
	v_coupon_id_old uuid;
	v_tax_code1_old character varying(255);
	v_tax_pct1_old numeric(15, 2); 
	v_tax_amt1_calc_old numeric(15, 4);
	v_tax_code2_old character varying(255);
	v_tax_pct2_old numeric(15, 4);
	v_tax_amt2_calc_old numeric(15, 4);
	v_setting_value text;
	v_msg2 text;
	module_code text;
	audit_log text;
BEGIN
/*

	DO $$
	DECLARE
		v_msg text;
		v_order_trans_item_line_id uuid;
	BEGIN
	
	select * from tb_product
	select * from tb_order_trans_table
	select * from tb_order_trans_item_line
	select * from tb_pymt_mode
	
		CALL pr_pos_add_trans_item_line(
			p_current_uid => 'tester',
			p_msg => null,
			p_order_trans_item_line_id => 'aa87a480-7f89-4387-8e6e-dd75e94a09a2',
			p_tr_date => null,
			p_tr_type => 'TS',
			p_tr_status => 'C', 
			p_order_trans_id => '84374986-ecb7-4aea-b76c-7ccd0be2965e',
			p_doc_no => 'TS2024121300001',
			p_product_id => 'a00143dd-09a1-47ce-8bb5-ad3f8a28805a',
			p_cost => null,
			p_sell_price => null,
			p_addon_amt => null,
			p_amt => null,
			p_qty => 1,
			p_discount_id => null,
			p_discount_amt => null,
			p_discount_pct => null,
			p_total_disc_amt => null,
			p_is_pymt => null,
			p_pymt_mode_id => null,
			p_ref_no => null,
			p_remarks => null,
			p_coupon_no => null,
			p_coupon_id => null,
			--p_store_id => '0f49bfb0-6414-43f1-bdc6-8c97a7290e6d',
			p_rid => null,
			p_axn => null,
			p_url => null,
			p_is_debug => 0
		);

		-- Output message and order_trans_item_line_id after calling the procedure
		RAISE NOTICE 'Message: %, Order Trans Item Line ID: %', v_msg, v_order_trans_item_line_id;
	END $$;

*/

	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_pos_add_trans_item_line - start';
	END IF;
	
	module_code := 'Order - Add Item Line';

	-- -------------------------------------
	-- validation
	-- -------------------------------------
	IF COALESCE(p_order_trans_id, fn_empty_guid()) = fn_empty_guid() THEN
		p_msg := 'Order Transaction ID cannot be blank!!';
		RETURN;
	END IF;
	
	IF NOT EXISTS (
		SELECT order_trans_id
		FROM tb_order_trans
		WHERE order_trans_id = p_order_trans_id
	) THEN
		p_msg := 'Invalid Order Transaction!!';
		RETURN;
	END IF;
	
	IF LENGTH(COALESCE(p_doc_no, '')) = 0 THEN
		p_msg := 'Order No cannot be blank!!';
		RETURN;
	END IF;
	
	IF NOT EXISTS (
		SELECT doc_no
		FROM tb_order_trans
		WHERE doc_no = p_doc_no
	) THEN
		p_msg := 'Invalid Order No!!';
		RETURN;
	END IF;
	
	IF p_tr_date IS NULL THEN
		p_tr_date := fn_get_current_trans_dt();
	ELSE	
		-- check tr_date cannot bigger than current_dt
		IF p_tr_date > v_today_dt THEN
			p_msg := 'Transaction Date cannot greater than current date!!';
			RETURN;
		END IF;
	END IF;
	
-- 	IF p_tr_date < v_today_dt THEN
-- 		p_msg := 'Please make sure night audit has been done, current transaction date: ' || p_tr_date::TEXT;
-- 		RETURN;
-- 	END IF;
	
	IF LENGTH(COALESCE(p_tr_type, '')) = 0 THEN
		p_msg := 'Transaction Type cannot be blank!!';
		RETURN;
	END IF;
	
	IF NOT EXISTS (
		SELECT tr_type_code
		FROM tb_tr_type
		WHERE tr_type_code = p_tr_type
	) THEN
		p_msg := 'Invalid Transaction Type!!';
		RETURN;
	END IF;
	
	IF p_tr_status IS NULL THEN 
		p_tr_status := 'C';
	END IF;
	
	IF NOT EXISTS (
		SELECT tr_status_code
		FROM tb_tr_status
		WHERE tr_status_code = p_tr_status
	) THEN
		p_msg := 'Invalid Transaction Status!!';
		RETURN;
	END IF;
	
	IF p_product_id IS NOT NULL THEN 
		IF NOT EXISTS (
			SELECT product_id
			FROM tb_product
			WHERE product_id = p_product_id
		) THEN
			p_msg := 'Invalid Product!!';
			RETURN;
		END IF;
	END IF;
	
	-- Get setting value
	v_setting_value := (SELECT sys_setting_value FROM tb_sys_setting WHERE sys_setting_title = 'OPERATION_MODE');
	
	-- -------------------------------------
	-- process
	-- -------------------------------------
		
	IF fn_to_guid(p_product_id) <> fn_empty_guid() THEN 
		
		p_is_pymt := 0;
		p_pymt_mode_id = fn_empty_guid();
		v_seq := (
			SELECT COALESCE(MAX(seq), 0)
			FROM tb_order_trans_item_line
			WHERE order_trans_id = p_order_trans_id
		) + 1;

		-- Get Product Tax Setting
		SELECT tax_code1, amt_include_tax1, tax_code2, amt_include_tax2, calc_tax2_after_tax1, sell_price
		INTO v_tax_code1, v_amt_include_tax1, v_tax_code2, v_amt_include_tax2, v_calc_tax2_after_tax1, p_sell_price
		FROM tb_product
		WHERE product_id = p_product_id;
		
		v_new_amt := p_sell_price + COALESCE(p_addon_amt, 0);

		-- Do Tax Calculation
		SELECT final_price, unit_price, tax_pct1, tax_amt1_calc, tax_pct2, tax_amt2_calc
		INTO p_amt, p_sell_price, v_tax_pct1, v_tax_amt1_calc, v_tax_pct2, v_tax_amt2_calc
		FROM fn_tax_calculation (
			v_tax_code1,
			v_tax_code2,
			v_amt_include_tax1,
			v_amt_include_tax2,
			v_calc_tax2_after_tax1,
			p_qty,
			v_new_amt
		);

		IF (COALESCE(p_discount_pct, 0) > 0 OR COALESCE(p_discount_amt, 0) > 0) THEN
			
			p_total_disc_amt := (p_qty * p_sell_price * COALESCE(p_discount_pct, 0) / 100) + COALESCE(p_discount_amt, 0);
			v_new_sell_price := p_sell_price * (1 - COALESCE(p_discount_pct, 0) / 100) - COALESCE(p_discount_amt, 0);
			
			RAISE NOTICE 'Discount Pct: %, Discount Amt: %, Qty: %, Sell Price: %, Total Disc Amt: %, Cost: %', p_discount_pct, p_discount_amt, p_qty, p_sell_price, p_total_disc_amt, p_cost;
			
			SELECT final_price, unit_price, tax_pct1, tax_amt1_calc, tax_pct2, tax_amt2_calc
			INTO p_amt, p_sell_price, v_tax_pct1, v_tax_amt1_calc, v_tax_pct2, v_tax_amt2_calc
			FROM fn_tax_calculation (
				v_tax_code1,
				v_tax_code2,
				v_amt_include_tax1,
				v_amt_include_tax2,
				v_calc_tax2_after_tax1,
				p_qty,
				v_new_sell_price
			);

		END IF;
			
	ELSIF fn_to_guid(p_pymt_mode_id) <> fn_empty_guid() THEN 
		
		IF NOT EXISTS (
			SELECT * 
			FROM tb_pymt_mode
			WHERE pymt_mode_id = p_pymt_mode_id
		) THEN
			p_msg := 'Invalid Payment Mode!!';
			RETURN;
		END IF;
			
		p_product_id := fn_empty_guid();
		p_cost := 0;
		p_qty := 0;
		p_sell_price := 0;
		p_is_pymt := 1;
		
		IF p_remarks = 'Amount Change Due' THEN
			v_seq := 2000;
		ELSE 
			v_seq := (
				SELECT COALESCE(MAX(seq), 999)
				FROM tb_order_trans_item_line
				WHERE order_trans_id = p_order_trans_id
				AND is_pymt = 1
			) + 1;
		END IF;
		
		p_discount_id := fn_empty_guid();
		p_discount_pct := NULL;
		p_discount_amt := NULL;
		p_total_disc_amt := NULL;
		
	END IF;
	
	RAISE NOTICE 'ID: %', p_order_trans_item_line_id;
	
	IF fn_to_guid(p_order_trans_item_line_id) = fn_empty_guid() THEN
		
		p_order_trans_item_line_id := gen_random_uuid();

		-- Insert Data
		INSERT INTO tb_order_trans_item_line (
			order_trans_item_line_id, created_on, created_by, modified_on, modified_by, tr_date, tr_type, tr_status, doc_no, product_id, qty, cost, sell_price,
			seq, order_trans_id, discount_id, discount_amt, discount_pct, total_disc_amt, is_pymt, pymt_mode_id, ref_no, remarks, amt, 
			price_override_on, price_override_by, coupon_no, coupon_id, tax_code1, tax_pct1, tax_amt1_calc, tax_code2, tax_pct2, tax_amt2_calc
		) values (
			p_order_trans_item_line_id, v_now, p_current_uid, v_now, p_current_uid, p_tr_date, p_tr_type, p_tr_status, p_doc_no, p_product_id, p_qty, p_cost, p_sell_price,
			v_seq, p_order_trans_id, p_discount_id, p_discount_amt, p_discount_pct, p_total_disc_amt, p_is_pymt, p_pymt_mode_id, p_ref_no, p_remarks, p_amt, 
			null, null, p_coupon_no, p_coupon_id, v_tax_code1, v_tax_pct1, v_tax_amt1_calc, v_tax_code2, v_tax_pct2, v_tax_amt2_calc
		);
		
		audit_log := 'Added New Item Line -  ' || 
						'Product: ' || p_product_id || ', ' ||
						'Sell Price: ' || p_sell_price || ', ' ||
						'Tax Amount 1 Calculate: ' || v_tax_amt1_calc || ', ' ||
						'Tax Amount 2 Calculate: ' || v_tax_amt2_calc || '.';
		
	ELSE
	
		SELECT 
			tr_date, tr_type, tr_status, doc_no, product_id, qty, cost, sell_price, seq, order_trans_id, discount_id, discount_amt, 
			discount_pct, total_disc_amt, is_pymt, pymt_mode_id, ref_no, remarks, amt, price_override_on, price_override_by, coupon_no, 
			coupon_id, tax_code1, tax_pct1, tax_amt1_calc, tax_code2, tax_pct2, tax_amt2_calc
		INTO 
			v_tr_date_old, v_tr_type_old, v_tr_status_old, v_doc_no_old, v_product_id_old, v_qty_old, v_cost_old, v_sell_price_old, v_seq_old, v_order_trans_id_old,
			v_discount_id_old, v_discount_amt_old, v_discount_pct_old, v_total_disc_amt_old, v_is_pymt_old, v_pymt_mode_id_old, v_ref_no_old, v_remarks_old, v_amt_old, 
			v_price_override_on_old, v_price_override_by_old, v_coupon_no_old, v_coupon_id_old, v_tax_code1_old, v_tax_pct1_old, v_tax_amt1_calc_old, 
			v_tax_code2_old, v_tax_pct2_old, v_tax_amt2_calc_old
		FROM tb_order_trans_item_line
		WHERE order_trans_item_line_id = p_order_trans_item_line_id;
		
		UPDATE tb_order_trans_item_line
		SET
			tr_date = p_tr_date, 
			tr_type = p_tr_type, 
			tr_status = p_tr_status, 
			doc_no = p_doc_no, 
			product_id = p_product_id, 
			qty = p_qty, 
			cost = p_cost, 
			sell_price = p_sell_price, 
			seq = v_seq_old, 
			order_trans_id = p_order_trans_id, 
			discount_id = p_discount_id, 
			discount_amt = p_discount_amt, 
			discount_pct = p_discount_pct, 
			total_disc_amt = p_total_disc_amt, 
			is_pymt = p_is_pymt, 
			pymt_mode_id = p_pymt_mode_id, 
			ref_no = p_ref_no, 
			remarks = p_remarks, 
			amt = p_amt, 
			price_override_on = v_price_override_on_old, 
			price_override_by = v_price_override_by_old, 
			coupon_no = p_coupon_no, 
			coupon_id = p_coupon_id, 
			tax_code1 = v_tax_code1, 
			tax_pct1 = v_tax_pct1, 
			tax_amt1_calc = v_tax_amt1_calc, 
			tax_code2 = v_tax_code2, 
			tax_pct2 = v_tax_pct2, 
			tax_amt2_calc = v_tax_amt2_calc
		WHERE order_trans_item_line_id = p_order_trans_item_line_id;
		
		audit_log := 'Updated Item Line -  ' || 
						'Product from ' || v_product_id_old || ' to ' || p_product_id || ', ' ||
						'Sell Price from ' || v_sell_price_old || ' to ' || p_sell_price || ', ' ||
						'Tax Amount 1 Calculate from ' || v_tax_amt1_calc_old || ' to ' || v_tax_amt1_calc || ', ' ||
						'Tax Amount 2 Calculate from ' || v_tax_amt2_calc_old || ' to ' || v_tax_amt2_calc || '.';
	
	END IF;
	
	RAISE NOTICE 'ID 2: %', p_order_trans_item_line_id;
		
	IF v_setting_value = 'Pay-first' THEN
		
		IF EXISTS (
			SELECT *
			FROM tb_order_trans_item_line
			WHERE 
				order_trans_id = p_order_trans_id
				AND is_pymt = 1
		) THEN
			
		-- Send order to kitchen printer
		
		END IF;

	END IF;

	
	p_msg := 'ok';
	
	-- Update the total amount
	CALL pr_order_trans_refresh (
		p_current_uid => p_current_uid,
		p_msg => v_msg2,
		p_order_trans_id => p_order_trans_id,
		p_doc_no => p_doc_no,
		p_tr_status => p_tr_status,  
		p_is_debug => 0  
	);
	
	IF v_msg2 <> 'ok' THEN 
		p_msg := 'Error happen in process!!';
		RETURN;
	END IF;
	
	-- Create Audit Log
	CALL pr_sys_append_audit_log (
		p_msg => audit_log
		, p_remarks => 'pr_pos_add_trans_item_line'
		, p_uid => p_current_uid
		, p_id1 => p_order_trans_item_line_id
		, p_id2 => null
		, p_id3 => null
     	, p_app_id => null
		, p_module_code => module_code
	); 

	-- -------------------------------------
	-- cleanup
	-- -------------------------------------
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_pos_add_trans_item_line - end';
	END IF;

END
$BODY$;