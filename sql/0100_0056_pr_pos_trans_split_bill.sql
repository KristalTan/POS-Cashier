CREATE OR REPLACE PROCEDURE pr_pos_trans_split_bill (
	IN p_current_uid character varying(255),
	OUT p_msg text,
	IN p_order_trans_id uuid,
	IN p_move_to integer, 						-- '0' -> new doc_no, '1' -> existing doc_no
	IN p_move_to_doc character varying(50),
	IN p_move_by integer, 						-- '0' -> by percentage, '1' -> by amount
	IN p_move_value numeric(15, 2),
	IN p_product_ids text,
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
	v_doc_no character varying(50);
	v_latest_doc_no character varying(50);
	v_sub_num integer;
	v_sub_trans integer = 1;
	v_doc_no_new character varying(50);
	v_order_trans_id_new uuid;
	v_order_trans_item_line_id_new uuid;
	v_split_by_pct numeric(15, 2);
	v_order_trans_id uuid;
	v_tr_date date; 
	v_order_trans_item_line_id uuid;
	v_product_id uuid; 
	v_qty integer;
	v_cost numeric(15, 4);
	v_sell_price numeric(15, 4);
	v_amt numeric(15, 4);
BEGIN
/*

*/

	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_pos_trans_split_bill - start';
	END IF;
	
	module_code := 'Order - Split Bill';

	-- Create temp table
	CREATE TEMPORARY TABLE item_line_tb (
		order_trans_item_line_id uuid, 
		tr_date date,
		tr_type character varying(50),
		tr_status character varying(50),
		doc_no character varying(50),
		product_id uuid,
		qty integer,
		cost numeric(15, 4),
		sell_price numeric(15, 4),
		seq integer,
		order_trans_id uuid,
		discount_id uuid,
		discount_amt numeric(15, 4),
		discount_pct numeric(15, 4),
		total_disc_amt numeric(15, 4),
		is_pymt integer,
		amt numeric(15, 4),
		price_override_on timestamp without time zone,
		price_override_by character varying(255),
		coupon_no character varying(50),
		coupon_id uuid,
		tax_code1 character varying(255),
		tax_pct1 numeric(15, 2),
		tax_amt1_calc numeric(15, 4),
		tax_code2 character varying(255),
		tax_pct2 numeric(15, 2),
		tax_amt2_calc numeric(15, 4)
	);

	-- -------------------------------------
	-- validation
	-- -------------------------------------	
	IF fn_to_guid(p_order_trans_id) = fn_empty_guid() THEN 
		p_msg := 'Invalid Bill!!';
		RETURN;
	END IF;
	
	IF LENGTH(COALESCE(p_product_ids, '')) = 0 THEN
		p_msg := 'Please select product to split!!';
		RETURN;
	END IF;
	
	IF p_move_value <= 0 THEN
		p_msg := 'The ' || 
				CASE 
					WHEN p_move_by = 0 THEN ' Percentage must greater than 0!!'
					WHEN p_move_by = 1 THEN ' Amount must greater than 0!!'
					ELSE 'Value must greater than 0!!'
				END;
		RETURN;
	END IF;
	
	IF p_move_to = 1 
	AND NOT EXISTS (
		SELECT doc_no
		FROM tb_order_trans
		WHERE doc_no = p_move_to_doc
	) THEN
		p_msg := 'Invalid Destination Order#!!';
		RETURN;
	END IF;
	
	-- -------------------------------------
	-- process
	-- -------------------------------------
	SELECT doc_no
	INTO v_doc_no
	FROM tb_order_trans
	WHERE order_trans_id = p_order_trans_id;
	
	v_order_trans_id_new := gen_random_uuid();
	v_order_trans_item_line_id_new := geb_random_uuid();
	
	IF p_move_to = 0 THEN
		IF (
			SELECT COUNT(doc_no)
			FROM tb_order_trans
			WHERE doc_no LIKE v_doc_no || '%'
		) > 1 THEN
		
			SELECT doc_no
			INTO v_latest_doc_no
			FROM tb_order_trans
			WHERE doc_no LIKE v_doc_no || '%';
			
			v_sub_num := SUBSTRING(v_latest_doc_no, LENGTH(v_doc_no) + 4, LENGTH(v_lastest_doc_no))::INTEGER;
			
			v_sub_trans := v_sub_num + 1;
			
			v_doc_no_new := v_doc_no::text || ' - '::text || v_sub_trans::text;
			
		ELSE
			
			v_doc_no_new := v_doc_no::text || ' - '::text || v_sub_trans::text;
		
		END IF;
	
	END IF;
	
	INSERT INTO item_line_tb (
		order_trans_item_line_id, tr_date, tr_type,	tr_status, doc_no, product_id, qty, cost, sell_price, seq, order_trans_id, discount_id, discount_amt,
		discount_pct, total_disc_amt, is_pymt, amt, price_override_on, price_override_by, coupon_no, coupon_id, tax_code1, tax_pct1, tax_amt1_calc,
		tax_code2, tax_pct2, tax_amt2_calc 
	)
	SELECT 
	FROM (
		SELECT 
			product_id = p.col::uuid
		FROM fn_str_to_table(p_product_ids) p
	) AS a
	INNER JOIN tb_order_trans_item_line b ON b.product_id = a.product_id
	WHERE order_trans_id = p_order_trans_id;
	
	-- Move by Percentage
	IF p_move_by = 1 THEN
		
		-- Percentage Move 100% (can consider as split by item)!!!!
		IF p_move_value = 100 THEN
			
			WHILE (SELECT COUNT(DISTINCT product_id) FROM item_line_tb) > 0 LOOP
			
				SELECT order_trans_id, doc_no, tr_date, order_trans_item_line_id, product_id, qty, cost, sell_price, amt
				INTO v_order_trans_id, v_doc_no, v_tr_date, v_order_trans_item_line_id, v_product_id, v_qty, v_cost, v_sell_price, v_amt
				FROM item_line_tb;
				
				-- 
				INSERT INTO tb_order_trans (
					order_trans_id, created_on, created_by, modified_on, modified_by, tr_date, tr_type, tr_status, doc_no, remarks, amt, total_tax,
					rounding_adj_amt, pos_station_id, discount_amt, discount_pct, total_disc, discount_remarks, with_deposit, is_credit_sales, outstanding_amt, 
					with_voucher, guest_id, pax, table_no, room_no, delivery_time, delivery_next_day
				)
				SELECT
					v_order_trans_id_new, v_now, p_current_uid, v_now, p_current_uid, tr_date, tr_type, tr_status, v_doc_no_new, remarks, amt, total_tax,
					rounding_adj_amt, pos_station_id, discount_amt, discount_pct, total_disc, discount_remarks, with_deposit, is_credit_sales, outstanding_amt, 
					with_voucher, guest_id, pax, table_no, room_no, delivery_time, delivery_next_day
				FROM tb_order_trans
				WHERE order_trans_id = v_order_trans_id;
				
				-- 
				INSERT INTO tb_order_trans_item_line (
					order_trans_item_line_id, created_on, created_by, modified_on, modified_by, tr_date, tr_type, tr_status, doc_no, product_id, qty, cost, 
					sell_price, seq, order_trans_id, discount_id, discount_amt, discount_pct, total_disc_amt, is_pymt, amt, price_override_on, price_override_by, 
					coupon_no, coupon_id, tax_code1, tax_pct1, tax_amt1_calc, tax_code2, tax_pct2, tax_amt2_calc 
				)
				SELECT 
					v_order_trans_item_line_id_new, created_on, created_by, modified_on, modified_by, tr_date, tr_type, tr_status, v_doc_no_new, product_id, qty, cost, 
					sell_price, seq, order_trans_id, discount_id, discount_amt, discount_pct, total_disc_amt, is_pymt, amt, price_override_on, price_override_by, 
					coupon_no, coupon_id, tax_code1, tax_pct1, tax_amt1_calc, tax_code2, tax_pct2, tax_amt2_calc
				FROM tb_order_trans_item_line
				WHERE order_trans_item_line_id = v_order_trans_item_line_id;
				
				DELETE FROM tb_order_trans_item_line
				WHERE order_trans_item_line_id = v_order_trans_item_line_id;
				
				DELETE FROM item_line_tb 
				WHERE order_trans_item_line_id = v_order_trans_item_line_id;
				
			END LOOP;
			
		ELSE 
		
			v_split_by_pct := p_move_value / 100;
			
			WHILE (SELECT COUNT(DISTINCT product_id) FROM item_line_tb) > 0 LOOP
			
				SELECT order_trans_id, doc_no, tr_date, order_trans_item_line_id, product_id, qty, cost, sell_price, amt
				INTO v_order_trans_id, v_doc_no, v_tr_date, v_order_trans_item_line_id, v_product_id, v_qty, v_cost, v_sell_price, v_amt
				FROM item_line_tb;
				
				-- 
				INSERT INTO tb_order_trans (
					order_trans_id, created_on, created_by, modified_on, modified_by, tr_date, tr_type, tr_status, doc_no, remarks, amt, total_tax,
					rounding_adj_amt, pos_station_id, discount_amt, discount_pct, total_disc, discount_remarks, with_deposit, is_credit_sales, outstanding_amt, 
					with_voucher, guest_id, pax, table_no, room_no, delivery_time, delivery_next_day
				)
				SELECT
					v_order_trans_id_new, v_now, p_current_uid, v_now, p_current_uid, tr_date, tr_type, tr_status, v_doc_no_new, remarks, amt, total_tax,
					rounding_adj_amt, pos_station_id, discount_amt, discount_pct, total_disc, discount_remarks, with_deposit, is_credit_sales, outstanding_amt, 
					with_voucher, guest_id, pax, table_no, room_no, delivery_time, delivery_next_day
				FROM tb_order_trans
				WHERE order_trans_id = v_order_trans_id;
				
				-- 
				INSERT INTO tb_order_trans_item_line (
					order_trans_item_line_id, created_on, created_by, modified_on, modified_by, tr_date, tr_type, tr_status, doc_no, product_id, qty, cost, 
					sell_price, seq, order_trans_id, discount_id, discount_amt, discount_pct, total_disc_amt, is_pymt, amt, price_override_on, price_override_by, 
					coupon_no, coupon_id, tax_code1, tax_pct1, tax_amt1_calc, tax_code2, tax_pct2, tax_amt2_calc 
				)
				SELECT 
					v_order_trans_item_line_id_new, created_on, created_by, modified_on, modified_by, tr_date, tr_type, tr_status, v_doc_no_new, product_id, qty, cost, 
					sell_price, seq, order_trans_id, discount_id, discount_amt, discount_pct, total_disc_amt, is_pymt, amt, price_override_on, price_override_by, 
					coupon_no, coupon_id, tax_code1, tax_pct1, tax_amt1_calc, tax_code2, tax_pct2, tax_amt2_calc
				FROM tb_order_trans_item_line
				WHERE order_trans_item_line_id = v_order_trans_item_line_id;
				
				UPDATE tb_order_trans_item_line
				SET
					qty = qty - v_split_by_pct,
					-- cost = cost ,
					sell_price = sell_price * (1 - v_split_by_pct),
					amt = amt * (1 - v_split_by_pct),
					tax_amt1_calc = tax_amt1_calc * (1 - v_split_by_pct),
					tax_amt2_calc = tax_amt2_calc * (1 - v_split_by_pct)
				WHERE order_trans_item_line_id = v_order_trans_item_line_id;
				
				UPDATE tb_order_trans_item_line
				SET
					qty = qty - v_split_by_pct,
					-- cost = cost ,
					sell_price = sell_price * (1 - v_split_by_pct),
					amt = amt * (1 - v_split_by_pct),
					tax_amt1_calc = tax_amt1_calc * (1 - v_split_by_pct),
					tax_amt2_calc = tax_amt2_calc * (1 - v_split_by_pct)
				WHERE order_trans_item_line_id = v_order_trans_item_line_id_new; 
				
				DELETE FROM item_line_tb 
				WHERE order_trans_item_line_id = v_order_trans_item_line_id;
				
			END LOOP;
		
		END IF;
		
	
	ELSE
	
	END IF;
	
	-- -------------------------------------
	-- cleanup
	-- -------------------------------------
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_pos_trans_split_bill - end';
	END IF;
	
	DROP TABLE item_line_tb;

END
$BODY$;