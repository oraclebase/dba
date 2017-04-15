-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/directory_permissions.sql
-- Author       : Tim Hall
-- Description  : Displays permission information about all directories.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @directory_permissions (directory_name)
-- Last Modified: 09/02/2016
-- -----------------------------------------------------------------------------------
SET LINESIZE 200

COLUMN grantee   FORMAT A20
COLUMN owner     FORMAT A10
COLUMN grantor   FORMAT A20
COLUMN privilege FORMAT A20

COLUMN 
SELECT * 
FROM   dba_tab_privs 
WHERE  table_name = UPPER('&1');
