CREATE OR REPLACE FUNCTION fn_to_guid(
	p_s anyelement
)
	RETURNS uuid
	LANGUAGE 'plpgsql'
	COST 100
	IMMUTABLE PARALLEL SAFE 
AS $$
BEGIN
/* 0000_0002_sys_fn_to_guid

sample:
	
	select 
		fn_to_guid('DE3FA7E5-FC7D-4381-A51-3F711CA5AB10'::uuid)
		, fn_to_guid('DE3FA7E5-FC7D-4381-A51-3F711CA5AB10'::text)
		, fn_to_guid('asaasasas'::text)

*/
    RETURN COALESCE(p_s::uuid, fn_empty_guid());

EXCEPTION
	WHEN OTHERS THEN
		RETURN fn_empty_guid();
END;
$$;
