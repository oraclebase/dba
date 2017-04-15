-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/services.sql
-- Author       : Tim Hall
-- Description  : Displays information about database services.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @services
-- Last Modified: 05/11/2004
-- -----------------------------------------------------------------------------------
SET LINESIZE 200
COLUMN name FORMAT A30
COLUMN network_name FORMAT A50

SELECT name,
       network_name
FROM   dba_services
ORDER BY name;