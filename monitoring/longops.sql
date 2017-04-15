-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/longops.sql
-- Author       : Tim Hall
-- Description  : Displays information on all long operations.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @longops
-- Last Modified: 03/07/2003
-- -----------------------------------------------------------------------------------

COLUMN sid FORMAT 999
COLUMN serial# FORMAT 9999999
COLUMN machine FORMAT A30
COLUMN progress_pct FORMAT 99999999.00
COLUMN elapsed FORMAT A10
COLUMN remaining FORMAT A10

SELECT s.sid,
       s.serial#,
       s.machine,
       ROUND(sl.elapsed_seconds/60) || ':' || MOD(sl.elapsed_seconds,60) elapsed,
       ROUND(sl.time_remaining/60) || ':' || MOD(sl.time_remaining,60) remaining,
       ROUND(sl.sofar/sl.totalwork*100, 2) progress_pct
FROM   v$session s,
       v$session_longops sl
WHERE  s.sid     = sl.sid
AND    s.serial# = sl.serial#;
