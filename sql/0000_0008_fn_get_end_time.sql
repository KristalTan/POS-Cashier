CREATE OR REPLACE FUNCTION fn_get_end_time (
	end_time character varying(50)
) RETURNS TIME 
	LANGUAGE 'plpgsql'
    COST 100
    IMMUTABLE PARALLEL SAFE 
AS $BODY$
BEGIN
/* 0000_0008_fn_get_end_time

sample:
	
	select 
		fn_get_end_time('10:59')

*/
    RETURN (end_time || ':59')::TIME;
END;
$BODY$;
