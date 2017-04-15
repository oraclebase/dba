-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/trace_run_details.sql
-- Author       : Tim Hall
-- Description  : Displays details of a specified trace run.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @trace_run_details.sql (runid)
-- Last Modified: 06/05/2005
-- -----------------------------------------------------------------------------------
SET LINESIZE 200
SET TRIMOUT ON

COLUMN runid FORMAT 99999
COLUMN event_seq FORMAT 99999
COLUMN event_unit_owner FORMAT A20
COLUMN event_unit FORMAT A20
COLUMN event_unit_kind FORMAT A20
COLUMN event_comment FORMAT A30

SELECT e.runid,
       e.event_seq,
       TO_CHAR(e.event_time, 'DD-MON-YYYY HH24:MI:SS') AS event_time,
       e.event_unit_owner,
       e.event_unit,
       e.event_unit_kind,
       e.proc_line,
       e.event_comment
FROM   plsql_trace_events e
WHERE  e.runid = &1
ORDER BY e.runid, e.event_seq;