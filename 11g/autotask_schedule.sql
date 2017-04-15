-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/11g/autotask_schedule.sql
-- Author       : Tim Hall
-- Description  : Displays the window schedule the automatic maintenance tasks.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @autotask_schedule.sql
-- Last Modified: 14-JUL-2016
-- -----------------------------------------------------------------------------------

COLUMN window_name FORMAT A20
COLUMN start_time FORMAT A40
COLUMN duration FORMAT A20

SELECT *
FROM   dba_autotask_schedule
ORDER BY start_time;


COLUMN FORMAT DEFAULT
