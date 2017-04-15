CREATE OR REPLACE FUNCTION part_hv_to_date (p_table_owner    IN  VARCHAR2,
                                            p_table_name     IN VARCHAR2,
                                            p_partition_name IN VARCHAR2)
  RETURN DATE
-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/miscellaneous/part_hv_to_date.sql
-- Author       : Tim Hall
-- Description  : Create a function to turn partition HIGH_VALUE column to a date.
-- Call Syntax  : @part_hv_to_date
-- Last Modified: 19/01/2012
-- Notes        : Has to re-select the value from the view as LONG cannot be passed as a parameter.
--                Example call:
--
-- SELECT a.partition_name, 
--        part_hv_to_date(a.table_owner, a.table_name, a.partition_name) as high_value
-- FROM   all_tab_partitions a;
--
-- Does no error handling. 
-- -----------------------------------------------------------------------------------
AS
  l_high_value VARCHAR2(32767);
  l_date DATE;
BEGIN
  SELECT high_value
  INTO   l_high_value
  FROM   all_tab_partitions
  WHERE  table_owner    = p_table_owner
  AND    table_name     = p_table_name
  AND    partition_name = p_partition_name;
  
  EXECUTE IMMEDIATE 'SELECT ' || l_high_value || ' FROM dual' INTO l_date;
  RETURN l_date;
END;
/