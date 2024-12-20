CREATE OR REPLACE FUNCTION fn_pos_station_list (
	p_current_uid character varying(255),
	p_is_in_use integer,
	p_rid integer,
	p_axn character varying(255),
	p_url character varying(255),
	p_is_debug integer DEFAULT 0
) RETURNS TABLE (
	pos_station_id uuid,
	modified_on timestamp,
	modified_by character varying(255), 
	pos_station_desc character varying(255),
	ip character varying(50), 
	default_printer_id uuid, 
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
/*

*/

	-- -------------------------------------
	-- validation
	-- -------------------------------------

	-- -------------------------------------
	-- process
	-- -------------------------------------
	IF COALESCE(p_is_in_use, -1) = -1 THEN 
		
		RETURN QUERY (
			SELECT a.pos_station_id, a.modified_on, a.modified_by, a.pos_station_desc, a.ip, a.default_printer_id, a.is_in_use, a.display_seq
			FROM tb_pos_station a
			LEFT JOIN tb_pos_printer b ON b.printer_id = a.default_printer_id
			ORDER BY a.display_seq
		);
		
	ELSE
	
		RETURN QUERY (
			SELECT 
				a.pos_station_id, null::timestamp AS modified_on, null::character varying AS modified_by, a.pos_station_desc, a.ip, a.default_printer_id, 
				null::integer AS is_in_use, null::character varying AS display_seq
			FROM tb_pos_station a
			LEFT JOIN tb_pos_printer b ON b.printer_id = a.default_printer_id
			WHERE a.is_in_use = p_is_in_use
			ORDER BY a.display_seq
		);

	END IF;
	
	-- -------------------------------------
	-- cleanup
	-- -------------------------------------
	
END
$$;
