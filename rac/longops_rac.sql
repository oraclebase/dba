-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/longops_rac.sql
-- Author       : Tim Hall
-- Description  : Displays information on all long operations for whole RAC.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @longops_rac
-- Last Modified: 03/07/2003
-- -----------------------------------------------------------------------------------

SET LINESIZE 200
COLUMN sid FORMAT 9999
COLUMN serial# FORMAT 9999999
COLUMN machine FORMAT A30
COLUMN progress_pct FORMAT 99999999.00
COLUMN elapsed FORMAT A10
COLUMN remaining FORMAT A10

SELECT s.inst_id,
       s.sid,
       s.serial#,
       s.username,
       s.module,
       ROUND(sl.elapsed_seconds/60) || ':' || MOD(sl.elapsed_seconds,60) elapsed,
       ROUND(sl.time_remaining/60) || ':' || MOD(sl.time_remaining,60) remaining,
       ROUND(sl.sofar/sl.totalwork*100, 2) progress_pct
FROM   gv$session s,
       gv$session_longops sl
WHERE  s.sid     = sl.sid
AND    s.inst_id = sl.inst_id
AND    s.serial# = sl.serial#;
