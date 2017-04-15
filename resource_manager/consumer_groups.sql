-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/resource_manager/consumer_groups.sql
-- Author       : Tim Hall
-- Description  : Lists all consumer groups.
-- Call Syntax  : @consumer_groups
-- Requirements : Access to the DBA views.
-- Last Modified: 12/11/2004
-- -----------------------------------------------------------------------------------
SET LINESIZE 200
SET VERIFY OFF

COLUMN status FORMAT A10
COLUMN comments FORMAT A50

SELECT consumer_group,
       status,
       comments
FROM   dba_rsrc_consumer_groups
ORDER BY consumer_group;