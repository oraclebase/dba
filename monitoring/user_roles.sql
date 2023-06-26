-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/user_roles.sql
-- Author       : Tim Hall
-- Description  : Displays a list of all roles and privileges granted to the specified user.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @user_roles (username)
-- Last Modified: 26/06/2023
-- -----------------------------------------------------------------------------------
set serveroutput on
set verify off

select a.granted_role,
       a.admin_option
from   dba_role_privs a
where  a.grantee = upper('&1')
order by a.granted_role;

select a.privilege,
       a.admin_option
from   dba_sys_privs a
where  a.grantee = upper('&1')
order by a.privilege;
               
set verify on
