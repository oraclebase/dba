-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/18c/lockdown_rules.sql
-- Author       : Tim Hall
-- Description  : Displays information about lockdown rules applis in the current container.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @lockdown_rules
-- Last Modified: 06/01/2019 - Switch to OUTER JOIN and alter ORDER BY.
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
       LEFT OUTER JOIN cdb_pdbs p ON lr.con_id = p.con_id
ORDER BY 1, 2;
