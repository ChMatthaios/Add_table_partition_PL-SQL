DECLARE
    start_date     DATE := TO_DATE ('2022-08-01', 'YYYY-MM-DD');                               -- Date you want to start
    end_date       DATE := TO_DATE ('2023-08-01', 'YYYY-MM-DD');                                 -- Date you want to end
    CURRENT_DATE   DATE := start_date;

    l_table_name   VARCHAR2 (150) := 'SCHEMA_NAME.TABLE_NAME';                    -- Table you want to add partitions to
    l_part_stmnt   VARCHAR2 (4000);
BEGIN
    l_part_stmnt := 'CREATE TABLE ' || l_table_name || ' PARTITION BY RANGE (date_column)('; -- The column for partition

    WHILE CURRENT_DATE <= end_date
    LOOP
        l_part_stmnt :=
               l_part_stmnt
            || CHR (10)
            || CHR (9)
            || 'PARTITION P_'
            || TO_CHAR (CURRENT_DATE, 'YYYYMM')
            || ' VALUES LESS THAN (TO_DATE('
            || TO_CHAR (CURRENT_DATE, 'YYYY-MM-DD HH24:MI:SS')
            || ', ''YYYY-MM-DD HH24:MI:SS'', ''NLS_CALENDAR=GREGORIAN''))'
            || CASE WHEN CURRENT_DATE != end_date THEN ',' END;

        CURRENT_DATE := ADD_MONTHS (CURRENT_DATE, 1);                  -- Next month so we don't create an infinite loop
    END LOOP;

    DBMS_OUTPUT.put_line (l_part_stmnt || CHR (10) || ');');

    -- Uncomment the next line when you're sure that you'll run the right partitions.
    -- EXECUTE IMMEDIATE l_part_stmnt || ')';
END;
/
