CREATE OR REPLACE PROCEDURE pr_pos_trans_item_disc (
	IN p_current_uid character varying(255),
	OUT p_msg text,
	IN p_order_trans_id uuid,
	IN p_order_trans_item_line_id uuid, 
	IN p_discount_amt numeric(15, 2),
	IN p_discount_pct numeric(15, 2),
	IN p_discount_id uuid,
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
	v_tax_code1 character varying(50);
	v_tax_pct1 numeric(15, 2);
	v_tax_code2 character varying(50);
	v_tax_pct2 numeric(15, 2);
	v_amt_include_tax1 integer;
	v_amt_include_tax2 integer;
	v_calc_tax2_after_tax1 integer;
	v_qty integer;
	v_cost_old numeric(15, 4);
	v_sell_amt_old numeric(15, 4);
	v_doc_no character varying(50);
	v_tr_status character varying(50);
	v_sell_amt_new numeric(15, 4);
	v_disc_amt numeric(15, 4);
	v_amt numeric(15, 4);
	v_unit_price_new numeric(15, 4);
	v_tax_amt1_calc numeric(15, 4);
	v_tax_amt2_calc numeric(15, 4);
	v_product_id uuid;
	v_msg text;
	v_now CONSTANT timestamp = current_timestamp;
	audit_log text;
	module_code text;
BEGIN
/*

	CALL pr_pos_trans_item_disc (
		p_current_uid => 'tester',
		p_msg => null,
		p_order_trans_id => '0ab06e15-76cf-4d32-9ec1-82eaf07e7f28',
		p_order_trans_item_line_id => 'a882a696-5fb5-4256-8c20-740b92b1fa3a', 
		p_discount_amt => null,
		p_discount_pct => 50,
		p_discount_id => null,
		p_override_by => null,
		p_override_remarks => 'testing',
		p_rid => null,
		p_axn => null,
		p_url => null
	);

*/
	
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_pos_trans_item_disc - start';
	END IF;
	
	module_code := 'Order - Item Discount';

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
	
	IF p_discount_pct <= 0 AND COALESCE(p_discount_amt, NULL::numeric) = NULL THEN
		p_msg := 'Discount percent must greater than 0!!';
		RETURN;
	END IF;
	
	IF p_discount_amt <= 0 AND COALESCE(p_discount_pct, NULL::numeric) = NULL THEN
		p_msg := 'Discount amount must greater than 0!!';
		RETURN;
	END IF;
	
	IF p_override_by IS NULL THEN
		p_override_by := p_current_uid;
	END IF;

	-- -------------------------------------
	-- process
	-- -------------------------------------
	SELECT b.tax_code1, b.tax_code2, b.amt_include_tax1, b.amt_include_tax2, b.calc_tax2_after_tax1, b.cost, a.qty, a.amt, a.tr_status, a.doc_no, a.product_id
	INTO v_tax_code1, v_tax_code2, v_amt_include_tax1, v_amt_include_tax2, v_calc_tax2_after_tax1, v_cost_old, v_qty, v_sell_amt_old, v_tr_status, v_doc_no, v_product_id
	FROM tb_order_trans_item_line a
	INNER JOIN tb_product b ON b.product_id = a.product_id
	WHERE
		a.order_trans_id = p_order_trans_id
		AND a.order_trans_item_line_id = p_order_trans_item_line_id;
		
	v_disc_amt := v_sell_amt_old * COALESCE(p_discount_pct, 0) / 100 + COALESCE(p_discount_amt, 0);
	
	v_sell_amt_new := v_sell_amt_old * (1 - COALESCE(p_discount_pct, 0) / 100) * (1 - COALESCE(p_discount_amt, 0) / v_sell_amt_old);
	
	IF v_sell_amt_new < 0 THEN
		p_msg := 'Discount amount or percent must not greater than item price!!';
		RETURN;
	END IF;
	
	-- Recalculate the tax
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
	
	UPDATE tb_order_trans_item_line
	SET 
		discount_id = p_discount_id,
		discount_amt = p_discount_amt,
		discount_pct = p_discount_pct,
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
	WHERE 
		order_trans_id = p_order_trans_id
		AND order_trans_item_line_id = p_order_trans_item_line_id;		
		
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
	
	audit_log := 'Item Discount - running by: ' || p_override_by::text || ', ' ||
					'Discount Percent: ' || p_discount_pct::text || ', ' ||
					'Discount Amount: ' || p_discount_amt::text || ', ' ||
					'Item: ' || v_product_id::text || '.';
	
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
		RAISE NOTICE 'pr_pos_trans_item_disc - end';
	END IF;

END
$BODY$;