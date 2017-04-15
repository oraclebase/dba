-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/session_io.sql
-- Author       : Tim Hall
-- Description  : Displays I/O information on all database sessions.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @session_io
-- Last Modified: 21-FEB-2005
-- -----------------------------------------------------------------------------------
SET LINESIZE 500
SET PAGESIZE 1000

COLUMN username FORMAT A15

SELECT NVL(s.username, '(oracle)') AS username,
       s.osuser,
       s.sid,
       s.serial#,
       si.block_gets,
       si.consistent_gets,
       si.physical_reads,
       si.block_changes,
       si.consistent_changes
FROM   v$session s,
       v$sess_io si
WHERE  s.sid = si.sid
ORDER BY s.username, s.osuser;

SET PAGESIZE 14
