-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/resource_manager/plan_directives.sql
-- Author       : Tim Hall
-- Description  : Lists all plan directives.
-- Call Syntax  : @plan_directives (plan-name or all)
-- Requirements : Access to the DBA views.
-- Last Modified: 12/11/2004
-- -----------------------------------------------------------------------------------
SET LINESIZE 200
SET VERIFY OFF

SELECT plan,
       group_or_subplan,
       cpu_p1,
       cpu_p2,
       cpu_p3,
       cpu_p4
FROM   dba_rsrc_plan_directives
WHERE  plan = DECODE(UPPER('&1'), 'ALL', plan, UPPER('&1'))
ORDER BY plan, cpu_p1 DESC, cpu_p2 DESC, cpu_p3 DESC;
