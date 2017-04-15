-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/11g/job_credentials.sql
-- Author       : Tim Hall
-- Description  : Displays scheduler information about job credentials.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @job_credentials
-- Last Modified: 23/08/2008
-- -----------------------------------------------------------------------------------
COLUMN credential_name FORMAT A25
COLUMN username FORMAT A20
COLUMN windows_domain FORMAT A20

SELECT credential_name,
       username,
       windows_domain
FROM   dba_scheduler_credentials
ORDER BY credential_name;
