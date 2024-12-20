CREATE OR REPLACE FUNCTION fn_notif_template_params (
	p_current_id character varying(255),
	p_action_id uuid,
	p_rid integer,
	p_axn character varying(255),
	p_url character varying(255),
	p_is_debug integer DEFAULT 0
) RETURNS TABLE (
	columns_name text
) 
LANGUAGE 'plpgsql'
AS $$
DECLARE

BEGIN
/*

	SELECT * FROM fn_notif_template_params(
		p_current_id => 'tester',
		p_action_id => '1296c008-4372-485f-91cf-81a544f476c2',
		p_rid => null,
		p_axn => null,
		p_url => null
	);

*/

	RETURN QUERY EXECUTE
        'SELECT b.column_name::text AS columns_name
		FROM information_schema.columns b
		WHERE table_schema = ''public''
		AND table_name = (
			SELECT a.rlt_tb 
			FROM tb_acn_rlt_tb a 
			WHERE a.action_id = $1
		)'
    USING p_action_id;

END
$$;