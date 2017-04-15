-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/10g/session_waits_rac.sql
-- Author       : Tim Hall
-- Description  : Displays information on all database session waits for the whole RAC.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @session_waits_rac
-- Last Modified: 02/07/2005
-- -----------------------------------------------------------------------------------
SET LINESIZE 200
SET PAGESIZE 1000

COLUMN username FORMAT A20
COLUMN event FORMAT A30
COLUMN wait_class FORMAT A15

SELECT s.inst_id,
       NVL(s.username, '(oracle)') AS username,
       s.sid,
       s.serial#,
       sw.event,
       sw.wait_class,
       sw.wait_time,
       sw.seconds_in_wait,
       sw.state
FROM   gv$session_wait sw,
       gv$session s
WHERE  s.sid     = sw.sid
AND    s.inst_id = sw.inst_id
ORDER BY sw.seconds_in_wait DESC;
