-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/profiler_run_details.sql
-- Author       : Tim Hall
-- Description  : Displays details of a specified profiler run.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @profiler_run_details.sql (runid)
-- Last Modified: 25/02/2005
-- -----------------------------------------------------------------------------------
SET LINESIZE 200
SET VERIFY OFF

COLUMN runid FORMAT 99999
COLUMN unit_number FORMAT 99999
COLUMN unit_type FORMAT A20
COLUMN unit_owner FORMAT A20

SELECT u.runid,
       u.unit_number,
       u.unit_type,
       u.unit_owner,
       u.unit_name,
       d.line#,
       d.total_occur,
       ROUND(d.total_time/d.total_occur) as time_per_occur,
       d.total_time,
       d.min_time,
       d.max_time
FROM   plsql_profiler_units u
       JOIN plsql_profiler_data d ON u.runid = d.runid AND u.unit_number = d.unit_number
WHERE  u.runid = &1
AND    d.total_time > 0
AND    d.total_occur > 0
ORDER BY (d.total_time/d.total_occur) DESC, u.unit_number, d.line#;
