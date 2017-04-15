-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/10g/job_running_chains.sql
-- Author       : Tim Hall
-- Description  : Displays scheduler information about job running chains.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @job_running_chains.sql
-- Last Modified: 26/10/2011
-- -----------------------------------------------------------------------------------
SET LINESIZE 200
COLUMN owner FORMAT A10
COLUMN job_name FORMAT A20
COLUMN chain_owner FORMAT A10
COLUMN chain_name FORMAT A15
COLUMN step_name FORMAT A25

SELECT owner,
       job_name,
       chain_owner,
       chain_name,
       step_name,
       state
FROM   dba_scheduler_running_chains
ORDER BY owner, job_name, chain_name, step_name;