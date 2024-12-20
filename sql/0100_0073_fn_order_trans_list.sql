CREATE OR REPLACE FUNCTION fn_order_trans_list (
	p_current_uid character varying(255),
	p_start_dt date,
	p_end_dt date,
	p_rid integer,
	p_axn character varying(50),
	p_url character varying(50),
	p_is_debug integer DEFAULT 0
) RETURNS TABLE (
	order_trans_id uuid, 
	doc_no character varying, 
	modified_on timestamp without time zone, 
	modified_by character varying, 
	tr_type_desc character varying, 
	tr_status character varying, 
	table_no character varying, 
	room_no character varying, 
	amt numeric(15, 2)
) 
LANGUAGE 'plpgsql'
AS $$
-- -------------------------------------
-- init
-- -------------------------------------
DECLARE 

BEGIN
/* 0100_0073_fn_order_trans_pending_list 

	SELECT * FROM fn_order_trans_list (
		p_current_uid => 'tester',
		p_start_dt => '2024-11-20',
		p_end_dt => '2024-11-22',
		p_rid => null,
		p_axn => 'history-list',
		p_url => null
	);

*/

	-- -------------------------------------
	-- validation
	-- -------------------------------------
	IF p_start_dt IS NULL THEN 
		p_start_dt := fn_get_current_trans_dt();
	END IF;
	
	IF p_end_dt IS NULL THEN 
		p_end_dt := fn_get_current_trans_dt();
	END IF;

	-- -------------------------------------
	-- process
	-- -------------------------------------
	IF p_axn = 'pending-list' THEN
	
		RETURN QUERY (
			SELECT 
				a.order_trans_id, a.doc_no, a.modified_on, a.modified_by, b.tr_type_desc, a.tr_status, a.table_no, a.room_no, a.amt
			FROM tb_order_trans a
			LEFT JOIN tb_tr_type b ON b.tr_type_code = a.tr_type
			WHERE 
				a.tr_status = 'C'
				AND a.outstanding_amt <> 0
				AND a.tr_date BETWEEN p_start_dt AND p_end_dt
		);
		
	ELSIF p_axn = 'history-list' THEN 
		
		RETURN QUERY (
			SELECT 
				a.order_trans_id, a.doc_no, a.modified_on, a.modified_by, b.tr_type_desc, a.tr_status, a.table_no, a.room_no, a.amt
			FROM tb_order_trans a
			LEFT JOIN tb_tr_type b ON b.tr_type_code = a.tr_type
			WHERE 
				a.tr_date BETWEEN p_start_dt AND p_end_dt
		);
		
	END IF;

	-- -------------------------------------
	-- cleanup
	-- -------------------------------------

END
$$;