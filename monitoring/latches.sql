-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/latches.sql
-- Author       : Tim Hall
-- Description  : Displays information about all current latches.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @latches
-- Last Modified: 15-JUL-2000
-- -----------------------------------------------------------------------------------
SET LINESIZE 200

SELECT l.latch#,
       l.name,
       l.gets,
       l.misses,
       l.sleeps,
       l.immediate_gets,
       l.immediate_misses,
       l.spin_gets
FROM   v$latch l
ORDER BY l.name;
