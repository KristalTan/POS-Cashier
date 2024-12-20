-- FUNCTION: public.fn_empty_guid()

-- DROP FUNCTION IF EXISTS public.fn_empty_guid();

CREATE OR REPLACE FUNCTION public.fn_empty_guid(
	)
    RETURNS uuid
    LANGUAGE 'plpgsql'
    COST 100
    IMMUTABLE PARALLEL SAFE 
AS $BODY$
BEGIN
/* 0000_0001_sys_fn_empty_guid

sample:
	
	select 
		fn_empty_guid()

*/
    RETURN '00000000-0000-0000-0000-000000000000'::uuid;
END;
$BODY$;

ALTER FUNCTION public.fn_empty_guid()
    OWNER TO postgres;
