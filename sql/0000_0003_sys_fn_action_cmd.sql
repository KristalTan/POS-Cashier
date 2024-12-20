CREATE OR REPLACE FUNCTION fn_action_cmd(
	p_action_code character varying,
	p_is_debug integer default 0
) 
RETURNS TABLE (
	sql_stm text,
	action_param_name character varying(255), 
	data_type character varying(255), 
	seq integer, 
	is_compulsory integer, 
	msg text
)
	LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000
AS $$
-- -------------------------------------
-- init
-- -------------------------------------
DECLARE
BEGIN
/**
0000_0003_fn_action_cmd

-- Example usage
SELECT * FROM fn_action_cmd(p_action_code => 'prod-category::s')

*/

    IF p_is_debug = 1 THEN
		RAISE NOTICE 'fn_action_cmd - start';
	END IF;
	
	-- -------------------------------------
	-- validation
	-- -------------------------------------
	IF NOT EXISTS (
		SELECT *
		FROM tb_action
		WHERE 
			action_code = p_action_code
	) THEN
		RETURN QUERY (
			SELECT NULL::TEXT
					, NULL::TEXT
					, NULL::VARCHAR
					, NULL::INT
					, NULL::INT
               		, 'Action Code: ' || p_action_code || ' is not exists!!'::TEXT
		);
		RETURN;
	END IF;
	
	-- -------------------------------------
	-- process
	-- -------------------------------------
	RETURN QUERY(
		SELECT 
			a.sql_q
			, b.action_param_name
			, b.data_type
			, b.seq
			, b.is_compulsory
			, NULL::text
		FROM tb_action a
		INNER JOIN tb_action_param b ON b.action_id = a.action_id
		WHERE a.action_code = p_action_code AND is_in_use = 1
		ORDER BY b.seq
	);
	RETURN;
	
	-- -------------------------------------
	-- cleanup
	-- -------------------------------------
	
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'fn_action_cmd - end';
	END IF;

END;
$$;
