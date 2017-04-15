-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/latch_holders.sql
-- Author       : Tim Hall
-- Description  : Displays information about all current latch holders.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @latch_holders
-- Last Modified: 15-JUL-2000
-- -----------------------------------------------------------------------------------
SET LINESIZE 200

SELECT l.name "Latch Name",
       lh.pid "PID",
       lh.sid "SID",
       l.gets "Gets (Wait)",
       l.misses "Misses (Wait)",
       l.sleeps "Sleeps (Wait)",
       l.immediate_gets "Gets (No Wait)",
       l.immediate_misses "Misses (Wait)"
FROM   v$latch l,
       v$latchholder lh
WHERE  l.addr = lh.laddr
ORDER BY l.name;
