-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/directory_permissions.sql
-- Author       : Tim Hall
-- Description  : Displays permissions on all directories.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @directory_permissions
-- Last Modified: 27/03/2024
-- -----------------------------------------------------------------------------------
column directory_name format a30
column grantee format a30
column privileges format a20

select table_name as directory_name,
       grantee,
       listagg(privilege,',') as privileges
from   dba_tab_privs 
where  table_name in (select directory_name from dba_directories)
group by table_name, grantee
order by 1, 2;
