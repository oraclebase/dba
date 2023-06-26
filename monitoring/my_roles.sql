-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/my_roles.sql
-- Author       : Tim Hall
-- Description  : Displays a list of all roles and privileges granted to the current user.
-- Requirements : Access to the USER views.
-- Call Syntax  : @user_roles
-- Last Modified: 26/06/2023
-- -----------------------------------------------------------------------------------
set serveroutput on
set verify off

select a.granted_role,
       a.admin_option
from   user_role_privs a
order by a.granted_role;

select a.privilege,
       a.admin_option
from   user_sys_privs a
order by a.privilege;
               
set verify on
