-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/10g/job_chain_rules.sql
-- Author       : Tim Hall
-- Description  : Displays scheduler information about job chain rules.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @job_chain_rules
-- Last Modified: 26/10/2011
-- -----------------------------------------------------------------------------------
SET LINESIZE 200
COLUMN owner FORMAT A10
COLUMN chain_name FORMAT A15
COLUMN rule_owner FORMAT A10
COLUMN rule_name FORMAT A15
COLUMN condition FORMAT A25
COLUMN action FORMAT A20
COLUMN comments FORMAT A25

SELECT owner,
       chain_name,
       rule_owner,
       rule_name,
       condition,
       action,
       comments
FROM   dba_scheduler_chain_rules
ORDER BY owner, chain_name, rule_owner, rule_name;