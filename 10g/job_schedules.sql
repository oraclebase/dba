-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/10g/job_schedules.sql
-- Author       : Tim Hall
-- Description  : Displays scheduler information about job schedules.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @job_schedules
-- Last Modified: 27/07/2005
-- -----------------------------------------------------------------------------------
SET LINESIZE 250

COLUMN owner FORMAT A20
COLUMN schedule_name FORMAT A30
COLUMN start_date FORMAT A35
COLUMN repeat_interval FORMAT A50
COLUMN end_date FORMAT A35
COLUMN comments FORMAT A40

SELECT owner,
       schedule_name,
       start_date,
       repeat_interval,
       end_date,
       comments
FROM   dba_scheduler_schedules
ORDER BY owner, schedule_name;
