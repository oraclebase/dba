-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/resource_manager/consumer_group_usage.sql
-- Author       : Tim Hall
-- Description  : Lists usage information of consumer groups.
-- Call Syntax  : @consumer_group_usage
-- Requirements : Access to the v$ views.
-- Last Modified: 12/11/2004
-- -----------------------------------------------------------------------------------
SELECT name,
       consumed_cpu_time
FROM   v$rsrc_consumer_group
ORDER BY name;
