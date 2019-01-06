-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/18c/lockdown_profiles.sql
-- Author       : Tim Hall
-- Description  : Displays information about lockdown profiles.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @lockdown_profiles
-- Last Modified: 30/06/2018
-- -----------------------------------------------------------------------------------
SET LINESIZE 200

COLUMN rule_type FORMAT A20
COLUMN rule FORMAT A20
COLUMN clause FORMAT A20
COLUMN clause_option FORMAT A20
COLUMN pdb_name FORMAT A30

SELECT lr.rule_type,
       lr.rule,
       lr.status,
       lr.clause,
       lr.clause_option,
       lr.users,
       lr.con_id,
       p.pdb_name
FROM   v$lockdown_rules lr
       JOIN cdb_pdbs p ON p.con_id = lr.con_id
ORDER BY 1;
