CREATE OR REPLACE FUNCTION fn_pymt_type_list (
	p_current_uid character varying(255),
	p_rid integer,
	p_axn character varying(255),
	p_url character varying(255),
	p_is_debug integer DEFAULT 0
) RETURNS TABLE (
	pymt_type_id integer,
	pymt_type_desc character varying(255)
)
LANGUAGE 'plpgsql'
AS $BODY$
-- -------------------------------------
-- init
-- -------------------------------------
DECLARE

BEGIN
/* 0100_0025_pr_pymt_type_list 
	
	SELECT * from fn_pymt_type_list('tester', 1, '0f49bfb0-6414-43f1-bdc6-8c97a7290e6d')
	
*/

	-- -------------------------------------
	-- validation
	-- -------------------------------------

	-- -------------------------------------
	-- process
	-- -------------------------------------
	RETURN QUERY (
		SELECT a.pymt_type_id, a.pymt_type_desc
		FROM tb_pymt_type a
		WHERE a.is_in_use = 1
		ORDER BY a.display_seq
	);

	-- -------------------------------------
	-- cleanup
	-- -------------------------------------

END
$BODY$;