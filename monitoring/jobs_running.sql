-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/jobs_running.sql
-- Author       : Tim Hall
-- Description  : Displays information about all jobs currently running.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @jobs_running
-- Last Modified: 15/07/2000
-- -----------------------------------------------------------------------------------
SET LINESIZE 500
SET PAGESIZE 1000
SET VERIFY OFF

SELECT a.job "Job",
       a.sid,
       a.failures "Failures",       
       Substr(To_Char(a.last_date,'DD-Mon-YYYY HH24:MI:SS'),1,20) "Last Date",      
       Substr(To_Char(a.this_date,'DD-Mon-YYYY HH24:MI:SS'),1,20) "This Date"             
FROM   dba_jobs_running a;

SET PAGESIZE 14
SET VERIFY ON