CREATE OR REPLACE FUNCTION pr_printer_type_list (
	p_current_uid character varying(255),
	p_rid integer,
	p_axn character varying(255),
	p_url character varying(255),
	p_is_debug integer DEFAULT 0
) RETURNS TABLE (
	printer_type_id integer,
	printer_type character varying(255)
)
LANGUAGE 'plpgsql'
AS $$
-- -------------------------------------
-- init
-- -------------------------------------
DECLARE

BEGIN
/* 0100_0071_pr_printer_type_list

*/

	-- -------------------------------------
	-- validation
	-- -------------------------------------

	-- -------------------------------------
	-- process
	-- -------------------------------------
	RETURN QUERY (
		SELECT a.printer_type_id, a.printer_type
		FROM tb_pos_printer_type a
		WHERE a.is_in_use = 1
		ORDER BY a.display_seq
	);

	-- -------------------------------------
	-- cleanup
	-- -------------------------------------

END
$$;