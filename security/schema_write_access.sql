-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/security/schema_write_access.sql
-- Author       : Tim Hall
-- Description  : Displays the users with write access to a specified schema.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @schema_write_access.sql (schema-name)
-- Last Modified: 05-MAY-2012
-- -----------------------------------------------------------------------------------

set verify off

-- Direct grants
select distinct grantee
from   dba_tab_privs
where  privilege in ('INSERT', 'UPDATE', 'DELETE')
and    owner = upper('&1')
union
-- Grants via a role
select distinct grantee
from   dba_role_privs
       join dba_users on grantee = username
where  granted_role IN (select distinct role
                        from   role_tab_privs
                        where  privilege in ('INSERT', 'UPDATE', 'DELETE')
                        and    owner = upper('&1')
                        union
                        select distinct role
                        from   role_sys_privs
                        where  privilege in ('INSERT ANY TABLE', 'UPDATE ANY TABLE', 'DELETE ANY TABLE'))
union
-- Access via ANY sys privileges
select distinct grantee
from   dba_sys_privs
join   dba_users on grantee = username
where  privilege in ('INSERT ANY TABLE', 'UPDATE ANY TABLE', 'DELETE ANY TABLE');
