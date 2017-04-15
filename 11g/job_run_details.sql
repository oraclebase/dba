-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/11g/job_run_details.sql
-- Author       : DR Timothy S Hall
-- Description  : Displays scheduler job information for previous runs.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @job_run_details (job-name | all)
-- Last Modified: 06/06/2014
-- -----------------------------------------------------------------------------------
SET LINESIZE 300 VERIFY OFF

COLUMN log_date FORMAT A35
COLUMN owner FORMAT A20
COLUMN job_name FORMAT A30
COLUMN error FORMAT A20
COLUMN req_start_date FORMAT A35
COLUMN actual_start_date FORMAT A35
COLUMN run_duration FORMAT A20
COLUMN credential_owner FORMAT A20
COLUMN credential_name FORMAT A20
COLUMN additional_info FORMAT A30

SELECT log_date,
       owner,
       job_name,
       status
       error,
       req_start_date,
       actual_start_date,
       run_duration,
       credential_owner,
       credential_name,
       additional_info
FROM   dba_scheduler_job_run_details
WHERE  job_name = DECODE(UPPER('&1'), 'ALL', job_name, UPPER('&1'))
ORDER BY log_date;
