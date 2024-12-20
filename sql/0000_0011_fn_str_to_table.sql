CREATE OR REPLACE FUNCTION fn_str_to_table(param TEXT)
RETURNS TABLE(col TEXT) AS
$$
-- -------------------------------------
-- init
-- -------------------------------------
DECLARE
    delimiter text := ';;';
    arr TEXT[];
BEGIN
/* 0000_0011_fn_str_to_table
	
	select * from fn_str_to_table (
		'9012112a-f762-43bb-804e-51dad5474dc8;;9012112a-f762-43bb-804e-51dad5474dc7'
	)
*/

	-- -------------------------------------
	-- validation
	-- -------------------------------------

	-- -------------------------------------
	-- process
	-- -------------------------------------
    -- Split the input string into an array of strings based on the delimiter
    arr := string_to_array(param, delimiter);
    
    -- Return each element of the array as a row
    RETURN QUERY 
    SELECT unnest(arr);
	
	-- -------------------------------------
	-- cleanup
	-- -------------------------------------
END;
$$ LANGUAGE plpgsql;
