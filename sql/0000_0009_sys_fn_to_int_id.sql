CREATE OR REPLACE FUNCTION fn_to_int_id(
	p_s integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    IMMUTABLE PARALLEL SAFE 
AS $BODY$
BEGIN
/* 0000_000_sys_fn_to_int_id

sample:
	
	select 
		fn_to_int_id(1::integer)
		, fn_to_int_id(null::integer)

*/
    RETURN COALESCE(p_s::integer, 0);

EXCEPTION
	WHEN OTHERS THEN
		RETURN 0;
END;
$BODY$;