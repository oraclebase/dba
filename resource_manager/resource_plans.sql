-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/resource_manager/resource_plans.sql
-- Author       : Tim Hall
-- Description  : Lists all resource plans.
-- Call Syntax  : @resource_plans
-- Requirements : Access to the DBA views.
-- Last Modified: 12/11/2004
-- -----------------------------------------------------------------------------------
SET LINESIZE 200
SET VERIFY OFF

COLUMN status FORMAT A10
COLUMN comments FORMAT A50

SELECT plan,
       status,
       comments
FROM   dba_rsrc_plans
ORDER BY plan;