-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/registry_history.sql
-- Author       : Tim Hall
-- Description  : Displays contents of the registry history
-- Requirements : Access to the DBA role.
-- Call Syntax  : @registry_history
-- Last Modified: 23/08/2008
-- -----------------------------------------------------------------------------------
SET LINESIZE 200

COLUMN action_time FORMAT A20
COLUMN action FORMAT A20
COLUMN namespace FORMAT A20
COLUMN version FORMAT A10
COLUMN comments FORMAT A30
COLUMN bundle_series FORMAT A10

SELECT TO_CHAR(action_time, 'DD-MON-YYYY HH24:MI:SS') AS action_time,
       action,
       namespace,
       version,
       id,
       comments,
       bundle_series
FROM   sys.registry$history
ORDER by action_time;