-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/sessions_by_machine.sql
-- Author       : Tim Hall
-- Description  : Displays the number of sessions for each client machine.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @sessions_by_machine
-- Last Modified: 20-JUL-2014
-- -----------------------------------------------------------------------------------
SET PAGESIZE 1000

SELECT machine,
       NVL(active_count, 0) AS active,
       NVL(inactive_count, 0) AS inactive,
       NVL(killed_count, 0) AS killed 
FROM   (SELECT machine, status, count(*) AS quantity
        FROM   v$session
        GROUP BY machine, status)
PIVOT  (SUM(quantity) AS count FOR (status) IN ('ACTIVE' AS active, 'INACTIVE' AS inactive, 'KILLED' AS killed))
ORDER BY machine;

SET PAGESIZE 14