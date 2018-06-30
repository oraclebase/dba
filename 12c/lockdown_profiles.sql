-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/12c/lockdown_profiles.sql
-- Author       : Tim Hall
-- Description  : Displays information about lockdown profiles.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @lockdown_profiles
-- Last Modified: 30/06/2018
-- -----------------------------------------------------------------------------------
SET LINESIZE 200

COLUMN profile_name FORMAT A30
COLUMN rule_type FORMAT A20
COLUMN rule FORMAT A20
COLUMN clause FORMAT A20
COLUMN clause_option FORMAT A20
COLUMN option_value FORMAT A20
COLUMN min_value FORMAT A20
COLUMN max_value FORMAT A20
COLUMN list FORMAT A20

SELECT profile_name,
       rule_type,
       rule,
       clause,
       clause_option,
       option_value,
       min_value,
       max_value,
       list,
       status
FROM   dba_lockdown_profiles
ORDER BY 1;

