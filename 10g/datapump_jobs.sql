-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/10g/datapump_jobs.sql
-- Author       : Tim Hall
-- Description  : Displays information about all Data Pump jobs.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @datapump_jobs
-- Last Modified: 28/01/2019
-- -----------------------------------------------------------------------------------
SET LINESIZE 150

COLUMN owner_name FORMAT A20
COLUMN job_name FORMAT A30
COLUMN operation FORMAT A10
COLUMN job_mode FORMAT A10
COLUMN state FORMAT A12

SELECT owner_name,
       job_name,
       TRIM(operation) AS operation,
       TRIM(job_mode) AS job_mode,
       state,
       degree,
       attached_sessions,
       datapump_sessions
FROM   dba_datapump_jobs
ORDER BY 1, 2;
