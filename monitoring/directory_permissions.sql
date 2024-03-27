-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/directory_permissions.sql
-- Author       : Tim Hall
-- Description  : Displays permission information about all directories.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @directory_permissions (directory_name)
-- Last Modified: 09/02/2016
-- -----------------------------------------------------------------------------------
set linesize 200

column grantee   format a20
column owner     format a10
column grantor   format a20
column privilege format a20

column 
select * 
from   dba_tab_privs 
where  table_name = upper('&1');
