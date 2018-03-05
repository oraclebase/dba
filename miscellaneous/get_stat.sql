-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/miscellaneous/get_stat.sql
-- Author       : Tim Hall
-- Description  : A function to return the specified statistic value.
-- Requirements : Select on V_$MYSTAT and V_$STATNAME.
-- Call Syntax  : Example of checking the amount of PGA memory allocated.
-- 
-- DECLARE
--   l_start NUMBER;
-- BEGIN
--   l_start := get_stat('session pga memory');
-- 
--   -- Do something.
-- 
--   DBMS_OUTPUT.put_line('PGA Memory Allocated : ' || (get_stat('session pga memory') - g_start) || ' bytes');
-- END;
-- /
-- 
-- Last Modified: 05/03/2018
-- -----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION get_stat (p_stat IN VARCHAR2) RETURN NUMBER AS
  l_return  NUMBER;
BEGIN
  SELECT ms.value
  INTO   l_return
  FROM   v$mystat ms,
         v$statname sn
  WHERE  ms.statistic# = sn.statistic#
  AND    sn.name = p_stat;
  RETURN l_return;
END get_stat;
/