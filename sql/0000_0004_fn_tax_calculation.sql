CREATE OR REPLACE FUNCTION fn_tax_calculation(
    p_tax_code1 character varying(50),
    p_tax_code2 character varying(50),
    p_amt_include_tax1 integer,
    p_amt_include_tax2 integer,
    p_calc_tax2_after_tax1 integer,
    p_qty integer,
    p_amt numeric(15, 4)
) RETURNS TABLE (
    final_price numeric(15, 4),
    unit_price numeric(15, 4),
    qty integer,
    tax_code1 character varying(50),
    tax_pct1 numeric(15, 4),
    tax_amt1_calc numeric(15, 4),
    tax_code2 character varying(50),
    tax_pct2 numeric(15, 4),
    tax_amt2_calc numeric(15, 4),
    amt_include_tax1 integer,
    amt_include_tax2 integer,
    tax2_after_tax1 integer
) LANGUAGE plpgsql AS
$BODY$
-- -------------------------------------
-- init
-- -------------------------------------
DECLARE
    t1 character varying(50);
    t2 character varying(50);
    p1 numeric(15, 4) := 0;
    p2 numeric(15, 4) := 0;
    amt_temp numeric(15, 4);
	amt_temp2 numeric(15, 4);
    amt1 numeric(15, 4);
    calc1 numeric(15, 4);
    calc2 numeric(15, 4);
    final_amt numeric(15, 4);
    tot_tax_pct numeric(15, 4);
BEGIN
/*
	
	SELECT * 
	FROM fn_tax_calculation(
		p_tax_code1 => 'SC',
		p_tax_code2 => 'SST-6%',
		p_amt_include_tax1 => 1, 
		p_amt_include_tax2 => 1, 
		p_calc_tax2_after_tax1 => 0, 
		p_qty => 1,
		p_amt => 8	
	); 
	
*/
    -- Ensure qty is not zero or negative
    IF COALESCE(p_qty, 0) <= 0 THEN 
        p_qty := 1; 
    END IF;

    -- Retrieve tax rate for the first tax code
    SELECT COALESCE(tax_pct / 100.0, 0)
    INTO p1
    FROM tb_tax
    WHERE tax_code = p_tax_code1
    AND is_in_use = 1
    LIMIT 1;

    -- Retrieve tax rate for the second tax code
    SELECT COALESCE(tax_pct / 100.0, 0)
    INTO p2
    FROM tb_tax
    WHERE tax_code = p_tax_code2
    AND is_in_use = 1
    LIMIT 1;

    -- Initialize tax codes
    t1 := p_tax_code1;
    t2 := p_tax_code2;

    -- Enforce zero values if null
    p_amt_include_tax1 := COALESCE(p_amt_include_tax1, 0);
    p_amt_include_tax2 := COALESCE(p_amt_include_tax2, 0);
    p_calc_tax2_after_tax1 := COALESCE(p_calc_tax2_after_tax1, 0);

    -- Default case when no tax is applied
    IF t1 IS NULL AND t2 IS NULL THEN
        final_amt := p_amt * p_qty;
    -- Case when both taxes are included
    ELSIF t1 IS NOT NULL AND t2 IS NOT NULL AND p_amt_include_tax1 = 1 AND p_amt_include_tax2 = 1 AND p_calc_tax2_after_tax1 = 0 THEN
        amt_temp := p_amt * p_qty;
		final_amt := amt_temp;
        tot_tax_pct := 1 + p1 + p2;
        amt_temp2 := amt_temp / tot_tax_pct;
		p_amt := amt_temp2 / p_qty;
		
        calc1 := amt_temp2 * p1;
        calc2 := final_amt - calc1 - (p_amt * p_qty);
    ELSE
        -- Case for tax1
        IF t1 IS NOT NULL THEN
            amt1 := p_amt * p_qty;
            IF p_amt_include_tax1 = 0 THEN
                calc1 := amt1 * p1;
                final_amt := amt1 + calc1;
            ELSE
                amt_temp := (amt1 / (1 + p1));
                calc1 := amt1 - amt_temp;
                final_amt := amt1;
                p_amt := amt_temp / p_qty;
            END IF;
        END IF;

        -- Case for tax2
        IF t2 IS NOT NULL THEN
            amt1 := p_amt * p_qty;
            IF p_calc_tax2_after_tax1 = 1 THEN
                amt1 := amt1 + calc1;
            END IF;

            IF p_amt_include_tax2 = 0 THEN
                calc2 := amt1 * p2;
                final_amt := final_amt + calc2;
            ELSE
                amt_temp := (amt1 / (1 + p2));
                calc2 := amt1 - amt_temp;
                final_amt := amt1;
                amt_temp2 := amt_temp / (1 + p2);
				calc1 := amt_temp - amt_temp2;
				amt_temp := amt_temp2;
				p_amt := amt_temp / p_qty;
            END IF;
        END IF;
    END IF;

    -- Return the result
    RETURN QUERY
    SELECT 
        final_amt AS final_price,
        ROUND(p_amt, 4) AS unit_price,
        p_qty AS qty,
        t1 AS tax_code1,
        CASE WHEN p1 * 100 = 0 THEN NULL ELSE p1 * 100 END AS tax_pct1,
        CASE WHEN calc1 = 0 THEN NULL ELSE calc1 END AS tax1,
        t2 AS tax_code2,
        CASE WHEN p2 * 100 = 0 THEN NULL ELSE p2 * 100 END AS tax_pct2,
        CASE WHEN calc2 = 0 THEN NULL ELSE calc2 END AS tax2,
        CASE WHEN p_amt_include_tax1 = 0 THEN NULL ELSE p_amt_include_tax1 END AS tax1_include,
        CASE WHEN p_amt_include_tax2 = 0 THEN NULL ELSE p_amt_include_tax2 END AS tax2_include,
        CASE WHEN p_calc_tax2_after_tax1 = 0 THEN NULL ELSE p_calc_tax2_after_tax1 END AS tax2_after_1;

END;
$BODY$;
