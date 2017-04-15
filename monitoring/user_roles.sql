-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/user_roles.sql
-- Author       : Tim Hall
-- Description  : Displays a list of all roles and privileges granted to the specified user.
-- Requirements : Access to the USER views.
-- Call Syntax  : @user_roles
-- Last Modified: 15/07/2000
-- -----------------------------------------------------------------------------------
SET SERVEROUTPUT ON
SET VERIFY OFF

SELECT a.granted_role,
       a.admin_option
FROM   user_role_privs a
ORDER BY a.granted_role;

SELECT a.privilege,
       a.admin_option
FROM   user_sys_privs a
ORDER BY a.privilege;
               
SET VERIFY ON
