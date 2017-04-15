-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/profiler_runs.sql
-- Author       : Tim Hall
-- Description  : Displays information on all profiler_runs.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @profiler_runs.sql
-- Last Modified: 25/02/2005
-- -----------------------------------------------------------------------------------
SET LINESIZE 200
SET TRIMOUT ON

COLUMN runid FORMAT 99999
COLUMN run_comment FORMAT A50

SELECT runid,
       run_date,
       run_comment,
       run_total_time
FROM   plsql_profiler_runs
ORDER BY runid;
