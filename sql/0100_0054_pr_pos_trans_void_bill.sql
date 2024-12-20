CREATE OR REPLACE PROCEDURE pr_pos_trans_void_bill (
	IN p_current_uid character varying(255),
	OUT p_msg text,
	IN p_order_trans_id uuid,
	IN p_override_remarks character varying(255),
	IN p_undo integer,
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
	v_action_id uuid;
	v_tr_status_old character varying(50);
	v_doc_no_old character varying(50);
	v_sent_to text;
	v_cc_to text;
	v_bcc_to text; mn
	v_style text;
	v_subject text;
	v_body text;
	v_msg text;
	v_mail_id uuid;
BEGIN 
/*

	CALL pr_pos_trans_void_bill (
		p_current_uid => 'tester',
		p_msg => null,
		p_order_trans_id => '8d97a22a-bd0b-48f8-951b-15bd66a1dda3',
		p_override_remarks => 'testing by lee',
		p_undo => null,
		p_rid => null,
		p_axn => null,
		p_url => null
	);

*/

	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_pos_trans_void_bill - start';
	END IF;
	
	module_code := 'Order - Void Bill';
	v_action_id := '5a4b20a0-f7d3-425d-b093-022c8160eb6b';
	
	-- -------------------------------------
	-- validation
	-- -------------------------------------
	IF fn_to_guid(p_order_trans_id) = fn_empty_guid() 
	AND NOT EXISTS (
		SELECT order_trans_id
		FROM tb_order_trans
		WHERE order_trans_id = p_order_trans_id
	) THEN
		p_msg := 'Invalid Bill!!';
		RETURN;
	END IF;
	
	IF LENGTH(COALESCE(p_override_remarks, '')) = 0 THEN
		p_msg := 'Override Reason cannot be blank!!';
		RETURN;
	END IF;
	
	SELECT tr_status, doc_no
	INTO v_tr_status_old, v_doc_no_old
	FROM tb_order_trans
	WHERE order_trans_id = p_order_trans_id;
	
	IF v_tr_status_old = 'X' THEN
		p_msg := 'This Bill has already been voided!!';
		RETURN;
	END IF;
	
	-- -------------------------------------
	-- process
	-- -------------------------------------
	UPDATE tb_order_trans
	SET 
		tr_status = 'X'
	WHERE order_trans_id = p_order_trans_id;
	
	UPDATE tb_order_trans_item_line
	SET
		tr_status = 'X'
	WHERE order_trans_id = p_order_trans_id;
	
	-- Handle the bill not yet pay and want void bill
	UPDATE tb_order_trans_table
	SET	
		order_trans_id = null, 
		doc_no = null,
		is_occ = 0
	WHERE order_trans_id = p_order_trans_id;
	
	INSERT INTO tb_order_trans_void_log (
		created_on, created_by, tr_date, tr_type, tr_status, order_trans_id, doc_no, remarks, amt, total_tax, rounding_adj_amt, pos_station_id, discount_amt, discount_pct, total_disc,
		discount_remarks, with_deposit, is_credit_sales, outstanding_amt, with_voucher, guest_id, pax, table_no, room_no, delivery_time, delivery_next_day, void_on, void_by
	)
	SELECT 
		created_on, created_by, tr_date, tr_type, tr_status, order_trans_id, doc_no, remarks, amt, total_tax, rounding_adj_amt, pos_station_id, discount_amt, discount_pct, total_disc,
		discount_remarks, with_deposit, is_credit_sales, outstanding_amt, with_voucher, guest_id, pax, table_no, room_no, delivery_time, delivery_next_day, v_now, p_current_uid
	FROM tb_order_trans
	WHERE order_trans_id = p_order_trans_id;
	 
	audit_log := 'Voided Bill Order #: ' || v_doc_no_old || '.';
	
	-- Create Notification
	IF EXISTS (
		SELECT notif_id
		FROM tb_notif 
		WHERE action_id = v_action_id
		AND is_in_use = 1
	) THEN
		SELECT sent_to, cc_to, bcc_to, style, subject, body
		INTO v_sent_to, v_cc_to, v_bcc_to, v_style, v_subject, v_body
		FROM tb_notif
		WHERE action_id = v_action_id;
		
		-- Prepare Email
		CALL pr_mail_sent_prepare (
			p_current_uid => p_current_uid,
			p_msg => v_msg,
			p_mail_id => v_mail_id,
			p_mail_type_id => 1,
			p_to => v_sent_to,
			p_cc => v_cc_to,
			p_bcc => v_bcc_to,
			p_subject => v_subject,
			p_body => v_body,
			p_fld_id1 => p_order_trans_id::text,
			p_fld_id2 => null,
			p_fld_id3 => null,
			p_attach_file => null
		);
		
		IF v_msg <> 'ok' THEN
			p_msg := 'Error happen during prepare mail!!';
			RETURN;
		END IF;
	END IF;
	
	p_msg := 'ok';
	
	-- Create Audit Log
	CALL pr_sys_append_audit_log (
		p_msg => audit_log
		, p_remarks => 'pr_pos_trans_void_bill'
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
		RAISE NOTICE 'pr_pos_trans_void_bill - end';
	END IF;

END
$BODY$;