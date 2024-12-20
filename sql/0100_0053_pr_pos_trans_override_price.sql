CREATE OR REPLACE PROCEDURE pr_pos_trans_override_price (
	IN p_current_uid character varying(255),
	OUT p_msg text,
	IN p_order_trans_id uuid,
	IN p_order_trans_item_line_id uuid,
	IN p_sell_price numeric(15, 4),
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
	v_tr_type character varying(50);
	v_tr_status character varying(50);
	v_tr_date date;
	v_qty integer;
	v_product_id uuid;
	v_cost_old numeric(15, 4);
	v_sell_price_old numeric(15, 4);
	v_tax_code1 character varying(255);
	v_amt_include_tax1 integer;
	v_tax_code2 character varying(255);
	v_amt_include_tax2 integer; 
	v_calc_tax2_after_tax1 integer;
	v_amt numeric(15, 4);
	v_unit_price_new numeric(15, 4);
	v_tax_pct1 numeric(15, 2);
	v_tax_amt1_calc numeric(15,4);
	v_tax_pct2 numeric(15, 2);
	v_tax_amt2_calc numeric(15, 4);
	v_doc_no character varying(50);
	v_now CONSTANT timestamp = current_timestamp;
	v_msg text;
	module_code text;
	audit_log text;
BEGIN
/* 0100_0053_pr_pos_trans_override_price

	CALL pr_pos_trans_override_price (
		p_current_uid => 'tester',
		p_msg => null,
		p_order_trans_id => '0ab06e15-76cf-4d32-9ec1-82eaf07e7f28',
		p_order_trans_item_line_id => 'a882a696-5fb5-4256-8c20-740b92b1fa3a',
		p_sell_price => 5,
		p_override_by => null,
		p_override_remarks => 'testing123456789',
		p_rid => null,
		p_axn => null,
		p_url => null
	);

*/

	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_pos_trans_override_price - start';
	END IF;
	
	module_code := 'Order - Override Price';

	-- -------------------------------------
	-- validation
	-- -------------------------------------
	IF fn_to_guid(p_order_trans_id) = fn_empty_guid()
	OR NOT EXISTS (
		SELECT order_trans_id
		FROM tb_order_trans
		WHERE
			order_trans_id = p_order_trans_id
	) THEN
		p_msg := 'Invalid Bill!!';
		RETURN;
	END IF; 
	
	IF fn_to_guid(p_order_trans_item_line_id) = fn_empty_guid()
	OR NOT EXISTS (
		SELECT order_trans_item_line_id
		FROM tb_order_trans_item_line
		WHERE
			order_trans_id = p_order_trans_id
			AND order_trans_item_line_id = p_order_trans_item_line_id
	) THEN
		p_msg := 'Invalid Item Line!!';
		RETURN;
	END IF;
	
	IF COALESCE(p_sell_price, 0) <= 0 THEN
		p_msg := 'Invalid Amount!!';
		RETURN;
	END IF;
	
	IF p_override_by IS NULL THEN
		p_override_by := p_current_uid;
	END IF;
	
	-- -------------------------------------
	-- process
	-- -------------------------------------
	SELECT tr_type, tr_status, tr_date, qty, product_id, doc_no
	INTO v_tr_type, v_tr_status, v_tr_date, v_qty, v_product_id, v_doc_no
	FROM tb_order_trans_item_line
	WHERE 
		order_trans_id = p_order_trans_id 
		AND order_trans_item_line_id = p_order_trans_item_line_id
	LIMIT 1;
	
	IF v_tr_status = 'C' THEN
		
		IF fn_to_guid(v_product_id) <> fn_empty_guid() 
		AND EXISTS (
			SELECT product_id 
			FROM tb_product 
			WHERE 
				product_id = v_product_id
				AND is_in_use = 1
		) THEN
		
			SELECT cost, sell_price, tax_code1, amt_include_tax1, tax_code2, amt_include_tax2, calc_tax2_after_tax1
			INTO v_cost_old, v_sell_price_old, v_tax_code1, v_amt_include_tax1, v_tax_code2, v_amt_include_tax2, v_calc_tax2_after_tax1
			FROM tb_product
			WHERE product_id = v_product_id;
			
			SELECT final_price, unit_price, tax_pct1, tax_amt1_calc, tax_pct2, tax_amt2_calc
			INTO v_amt, v_unit_price_new, v_tax_pct1, v_tax_amt1_calc, v_tax_pct2, v_tax_amt2_calc
			FROM fn_tax_calculation (
				p_tax_code1 => v_tax_code1,
				p_tax_code2 => v_tax_code2,
				p_amt_include_tax1 => v_amt_include_tax1,
				p_amt_include_tax2 => v_amt_include_tax2,
				p_calc_tax2_after_tax1 => v_calc_tax2_after_tax1,
				p_qty => v_qty,
				p_amt => p_sell_price
			);
			
			UPDATE tb_order_trans_item_line
			SET
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
			WHERE 
				order_trans_id = p_order_trans_id 
				AND order_trans_item_line_id = p_order_trans_item_line_id;
		
		END IF;
		
	END IF;
	
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
		, p_remarks => 'pr_pos_trans_item_disc'
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
		RAISE NOTICE 'pr_pos_trans_override_price - end';
	END IF;

END
$BODY$;