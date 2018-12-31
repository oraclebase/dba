-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/script_creation/job_ddl.sql
-- Author       : Tim Hall
-- Description  : Creates the DDL for the specified job.
-- Call Syntax  : @job_ddl (schema-name) (job-name)
-- Last Modified: 31/12/2018
-- -----------------------------------------------------------------------------------
SET LONG 20000 LONGCHUNKSIZE 20000 PAGESIZE 0 LINESIZE 1000 FEEDBACK OFF VERIFY OFF TRIMSPOOL ON

BEGIN
   DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform, 'SQLTERMINATOR', true);
   DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform, 'PRETTY', true);
END;
/

SELECT DBMS_METADATA.get_ddl ('PROCOBJ', job_name, owner)
FROM   all_scheduler_jobs
WHERE  owner    = UPPER('&1')
AND    job_name = DECODE(UPPER('&2'), 'ALL', job_name, UPPER('&2'));

SET PAGESIZE 14 LINESIZE 100 FEEDBACK ON VERIFY ON