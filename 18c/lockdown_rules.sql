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

SELECT rule_type,
       rule,
       clause,
       clause_option,
       status,
       users,
       con_id
FROM   v$lockdown_rules
ORDER BY 1;
