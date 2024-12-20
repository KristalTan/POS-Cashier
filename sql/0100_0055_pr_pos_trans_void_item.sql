CREATE OR REPLACE PROCEDURE pr_pos_trans_void_item (
	IN p_current_uid character varying(255),
	OUT p_msg text,
	IN p_order_trans_id uuid,
	IN p_order_trans_item_line_id uuid,
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
	v_now CONSTANT timestamp = current_timestamp;
	audit_log text;
	module_code text;
	v_tr_status character varying(50);
	v_tr_date date;
	v_qty integer;
	v_product_id uuid;
	v_amt_old numeric(15, 4);
	v_doc_no character varying(50);
	v_msg text;
BEGIN
/*

	CALL pr_pos_trans_void_item (
		p_current_uid => 'tester',
		p_msg => null,
		p_order_trans_id => '0ab06e15-76cf-4d32-9ec1-82eaf07e7f28',
		p_order_trans_item_line_id => 'a882a696-5fb5-4256-8c20-740b92b1fa3a',
		p_override_by => null,
		p_override_remarks => 'testing12345',
		p_rid => null,
		p_axn => null,
		p_url => null
	);

*/

	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_pos_trans_void_item - start';
	END IF;
	
	module_code := 'Order - Void Item Line';

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
	
	IF p_override_by IS NULL THEN
		p_override_by := p_current_uid;
	END IF;

	-- -------------------------------------
	-- process
	-- -------------------------------------
	SELECT tr_status, tr_date, qty, product_id, amt, doc_no
	INTO v_tr_status, v_tr_date, v_qty, v_product_id, v_amt_old, v_doc_no
	FROM tb_order_trans_item_line
	WHERE 
		order_trans_id = p_order_trans_id 
		AND order_trans_item_line_id = p_order_trans_item_line_id
	LIMIT 1;
	
	INSERT INTO tb_order_trans_item_line_void (
		order_trans_item_line_id, created_on, created_by, tr_date, tr_type, tr_status, doc_no, product_id, qty, cost, sell_price, seq, order_trans_id, discount_id,
		discount_amt, discount_pct, total_disc_amt, is_pymt, pymt_mode_id, ref_no, remarks, amt, price_override_on, price_override_by, coupon_no, tax_code1, 
		tax_pct1, tax_amt1_calc, tax_code2, tax_pct2, tax_amt2_calc, void_on, void_by
	)
	SELECT 
		order_trans_item_line_id, created_on, created_by, tr_date, tr_type, 'X', doc_no, product_id, qty, cost, sell_price, seq, order_trans_id, discount_id,
		discount_amt, discount_pct, total_disc_amt, is_pymt, pymt_mode_id, ref_no, remarks, amt, price_override_on, price_override_by, coupon_no, tax_code1, 
		tax_pct1, tax_amt1_calc, tax_code2, tax_pct2, tax_amt2_calc, v_now, p_override_by
	FROM tb_order_trans_item_line
	WHERE 
		order_trans_id = p_order_trans_id 
		AND order_trans_item_line_id = p_order_trans_item_line_id
	LIMIT 1;
	
	DELETE FROM tb_order_trans_item_line 
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
	
	-- Create Audit Log
	CALL pr_sys_append_audit_log (
		p_msg => audit_log
		, p_remarks => 'pr_pos_trans_void_item'
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
		RAISE NOTICE 'pr_pos_trans_void_item - end';
	END IF;

END
$BODY$;