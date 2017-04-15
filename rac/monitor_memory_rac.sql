-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/monitor_memory_rac.sql
-- Author       : Tim Hall
-- Description  : Displays memory allocations for the current database sessions for the whole RAC.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @monitor_memory_rac
-- Last Modified: 15-JUL-2000
-- -----------------------------------------------------------------------------------
SET LINESIZE 200

COLUMN username FORMAT A20
COLUMN module FORMAT A20

SELECT a.inst_id,
       NVL(a.username,'(oracle)') AS username,
       a.module,
       a.program,
       Trunc(b.value/1024) AS memory_kb
FROM   gv$session a,
       gv$sesstat b,
       gv$statname c
WHERE  a.sid = b.sid
AND    a.inst_id = b.inst_id
AND    b.statistic# = c.statistic#
AND    b.inst_id = c.inst_id
AND    c.name = 'session pga memory'
AND    a.program IS NOT NULL
ORDER BY b.value DESC;