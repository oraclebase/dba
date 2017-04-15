-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/10g/job_chains.sql
-- Author       : Tim Hall
-- Description  : Displays scheduler information about job chains.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @job_chains
-- Last Modified: 26/10/2011
-- -----------------------------------------------------------------------------------
SET LINESIZE 200
COLUMN owner FORMAT A10
COLUMN chain_name FORMAT A15
COLUMN rule_set_owner FORMAT A10
COLUMN rule_set_name FORMAT A15
COLUMN comments FORMAT A15

SELECT owner,
       chain_name,
       rule_set_owner,
       rule_set_name,
       number_of_rules,
       number_of_steps,
       enabled,
       comments
FROM   dba_scheduler_chains;