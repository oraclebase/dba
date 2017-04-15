-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/10g/db_usage_hwm.sql
-- Author       : Tim Hall
-- Description  : Displays high water mark statistics.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @db_usage_hwm
-- Last Modified: 26-NOV-2004
-- -----------------------------------------------------------------------------------

COLUMN name  FORMAT A40
COLUMN highwater FORMAT 999999999999
COLUMN last_value FORMAT 999999999999
SET PAGESIZE 24

SELECT hwm1.name,
       hwm1.highwater,
       hwm1.last_value
FROM   dba_high_water_mark_statistics hwm1
WHERE  hwm1.version = (SELECT MAX(hwm2.version)
                       FROM   dba_high_water_mark_statistics hwm2
                       WHERE  hwm2.name = hwm1.name)
ORDER BY hwm1.name;

COLUMN FORMAT DEFAULT
