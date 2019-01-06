-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/12c/lockdown_profiles.sql
-- Author       : Tim Hall
-- Description  : Displays information about lockdown profiles.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @lockdown_profiles
-- Last Modified: 05/01/2019 - Increase the LINESIZE setting and include PDB ID and name.
--                             Switch to LEFT OUTER JOIN. Alter column order.
-- -----------------------------------------------------------------------------------
SET LINESIZE 250

COLUMN pdb_name FORMAT A30
COLUMN profile_name FORMAT A30
COLUMN rule_type FORMAT A20
COLUMN rule FORMAT A20
COLUMN clause FORMAT A20
COLUMN clause_option FORMAT A20
COLUMN option_value FORMAT A20
COLUMN min_value FORMAT A20
COLUMN max_value FORMAT A20
COLUMN list FORMAT A20

SELECT lp.con_id,
       p.pdb_name,
       lp.profile_name,
       lp.rule_type,
       lp.status,
       lp.rule,
       lp.clause,
       lp.clause_option,
       lp.option_value,
       lp.min_value,
       lp.max_value,
       lp.list
FROM   cdb_lockdown_profiles lp
       LEFT OUTER JOIN cdb_pdbs p ON lp.con_id = p.con_id
ORDER BY 1, 3;
