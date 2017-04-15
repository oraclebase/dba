-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/12c/cdb_resource_plans.sql
-- Author       : Tim Hall
-- Description  : Displays CDB resource plans.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @cdb_resource_plans.sql
-- Last Modified: 22-MAR-2014
-- -----------------------------------------------------------------------------------

COLUMN plan FORMAT A30
COLUMN comments FORMAT A30
COLUMN status FORMAT A10
SET LINESIZE 100

SELECT plan_id,
       plan,
       comments,
       status,
       mandatory
FROM   dba_cdb_rsrc_plans
ORDER BY plan;
