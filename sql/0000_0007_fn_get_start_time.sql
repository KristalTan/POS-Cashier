CREATE OR REPLACE FUNCTION fn_get_start_time (
	start_time character varying(50)
) RETURNS TIME 
	LANGUAGE 'plpgsql'
    COST 100
    IMMUTABLE PARALLEL SAFE 
AS $BODY$
BEGIN
/* 0000_0007_fn_get_start_time

sample:
	
	select 
		fn_get_start_time('07:00')

*/
    RETURN (start_time || ':00')::TIME;
END;
$BODY$;
