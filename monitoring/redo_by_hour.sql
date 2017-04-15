-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/redo_by_hour.sql
-- Author       : Tim Hall
-- Description  : Lists the volume of archived redo by hour for the specified day.
-- Call Syntax  : @redo_by_hour (day 0=Today, 1=Yesterday etc.)
-- Requirements : Access to the v$views.
-- Last Modified: 11/10/2013
-- -----------------------------------------------------------------------------------

SET VERIFY OFF PAGESIZE 30

WITH hours AS (
  SELECT TRUNC(SYSDATE) - &1 + ((level-1)/24) AS hours
  FROM   dual
  CONNECT BY level < = 24
)
SELECT h.hours AS date_hour,
       ROUND(SUM(blocks * block_size)/1024/1024/1024,2) size_gb
FROM   hours h
       LEFT OUTER JOIN v$archived_log al ON h.hours = TRUNC(al.first_time, 'HH24')
GROUP BY h.hours
ORDER BY h.hours;

SET VERIFY ON PAGESIZE 14