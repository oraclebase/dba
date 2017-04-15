-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/12c/cdb_resource_plan_directives.sql
-- Author       : Tim Hall
-- Description  : Displays CDB resource plan directives.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @cdb_resource_plan_directives.sql (plan-name or all)
-- Last Modified: 22-MAR-2014
-- -----------------------------------------------------------------------------------

COLUMN plan FORMAT A30
COLUMN pluggable_database FORMAT A25
SET LINESIZE 100 VERIFY OFF

SELECT plan, 
       pluggable_database, 
       shares, 
       utilization_limit AS util,
       parallel_server_limit AS parallel
FROM   dba_cdb_rsrc_plan_directives
WHERE  plan = DECODE(UPPER('&1'), 'ALL', plan, UPPER('&1'))
ORDER BY plan, pluggable_database;

SET VERIFY ON