-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/10g/job_classes.sql
-- Author       : Tim Hall
-- Description  : Displays scheduler information about job classes.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @job_classes
-- Last Modified: 27/07/2005
-- -----------------------------------------------------------------------------------
SET LINESIZE 200

COLUMN service FORMAT A20
COLUMN comments FORMAT A40

SELECT job_class_name,
       resource_consumer_group,
       service,
       logging_level,
       log_history,
       comments
FROM   dba_scheduler_job_classes
ORDER BY job_class_name;
