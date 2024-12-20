CREATE OR REPLACE FUNCTION fn_pymt_mode_list (
	p_current_uid character varying(255),
	p_is_in_use integer,
	p_rid integer,
	p_axn character varying(255),
	p_url character varying(255),
	p_is_debug integer DEFAULT 0
) RETURNS TABLE (
	pymt_mode_id uuid,
	modified_on timestamp,
	modified_by character varying(255),
	pymt_mode_desc character varying(255),
	pymt_type_id integer,
	pymt_type_desc character varying(255),
	is_in_use integer
)
LANGUAGE 'plpgsql'
AS $BODY$
-- -------------------------------------
-- init
-- -------------------------------------
DECLARE

BEGIN
/* 0100_0025_pr_pymt_mode_list 
	
	SELECT * from fn_pymt_mode_list('tester', 1, '0f49bfb0-6414-43f1-bdc6-8c97a7290e6d')
	
*/

	-- -------------------------------------
	-- validation
	-- -------------------------------------

	-- -------------------------------------
	-- process
	-- -------------------------------------
	IF COALESCE(p_is_in_use, -1) = -1 THEN
		
		RETURN QUERY (
			SELECT a.pymt_mode_id, a.modified_on, a.modified_by, a.pymt_mode_desc, a.pymt_type_id, b.pymt_type_desc, a.is_in_use
			FROM tb_pymt_mode a
			INNER JOIN tb_pymt_type b ON b.pymt_type_id = a.pymt_type_id
			ORDER BY 
				a.pymt_mode_desc
		);
		
	ELSE
		
		RETURN QUERY (
			SELECT 
				a.pymt_mode_id, null::timestamp AS modified_on, null::character varying AS modified_by, a.pymt_mode_desc, 
				null::integer AS pymt_type_id, null::character varying AS pymt_type_desc, null::integer AS is_in_use
			FROM tb_pymt_mode a
			INNER JOIN tb_pymt_type b ON b.pymt_type_id = a.pymt_type_id
			WHERE a.is_in_use = p_is_in_use
			ORDER BY 
				a.pymt_mode_desc
		);
	
	END IF;

	-- -------------------------------------
	-- cleanup
	-- -------------------------------------

END
$BODY$;