-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/redo_by_day.sql
-- Author       : Tim Hall
-- Description  : Lists the volume of archived redo by day for the specified number of days.
-- Call Syntax  : @redo_by_day (days)
-- Requirements : Access to the v$views.
-- Last Modified: 11/10/2013
-- -----------------------------------------------------------------------------------

SET VERIFY OFF

SELECT TRUNC(first_time) AS day,
       ROUND(SUM(blocks * block_size)/1024/1024/1024,2) size_gb
FROM   v$archived_log
WHERE  TRUNC(first_time) >= TRUNC(SYSDATE) - &1
GROUP BY TRUNC(first_time)
ORDER BY TRUNC(first_time);

SET VERIFY ON