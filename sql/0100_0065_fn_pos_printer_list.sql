CREATE OR REPLACE FUNCTION fn_pos_printer_list (
	p_current_uid character varying(255),
	p_is_in_use integer,
	p_rid integer,
	p_axn character varying(255),
	p_url character varying(255),
	p_is_debug integer DEFAULT 0
) RETURNS TABLE (
	pos_printer_id uuid,
	modified_on timestamp,
	modified_by character varying(255), 
	printer_ip_address character varying(50),
	printer_name character varying(255),
	is_kitchen_printer integer,
	is_receipt_printer integer,
	is_in_use integer,
	display_seq character varying(6)
)
LANGUAGE plpgsql
AS $$
-- -------------------------------------
-- init
-- -------------------------------------
DECLARE 
BEGIN
/* 0100_0065_fn_pos_printer_list

*/

	-- -------------------------------------
	-- validation
	-- -------------------------------------

	-- -------------------------------------
	-- process
	-- -------------------------------------
	IF COALESCE(p_is_in_use, -1) = -1 THEN
	
		RETURN QUERY (
			SELECT a.pos_printer_id, a.modified_on, a.modified_by, a.printer_ip_address, a.printer_name, a.is_kitchen_printer, a.is_receipt_printer, a.is_in_use, a.display_seq
			FROM tb_pos_printer a
			ORDER BY a.display_seq, a.printer_name
		);
	
	ELSE
	
		RETURN QUERY (
			SELECT 
				a.pos_printer_id, null::timestamp AS modified_on, null::character varying AS modified_by, null::character varying AS printer_ip_address, 
				a.printer_name, null::integer AS is_kitchen_printer, null::integer AS is_receipt_printer, null::integer AS is_in_use, null::character varying AS display_seq
			FROM tb_pos_printer a
			WHERE a.is_in_use = p_is_in_use
			ORDER BY a.display_seq, a.printer_name
		);
	
	END IF;
	
	-- -------------------------------------
	-- cleanup
	-- -------------------------------------
	
END
$$;