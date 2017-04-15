-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/role_privs.sql
-- Author       : Tim Hall
-- Description  : Displays a list of all roles and privileges granted to the specified role.
-- Requirements : Access to the USER views.
-- Call Syntax  : @role_privs (role-name, ALL)
-- Last Modified: 15/07/2000
-- -----------------------------------------------------------------------------------
SET SERVEROUTPUT ON
SET VERIFY OFF

SELECT a.role,
       a.granted_role,
       a.admin_option
FROM   role_role_privs a
WHERE  a.role = DECODE(UPPER('&1'), 'ALL', a.role, UPPER('&1'))
ORDER BY a.role, a.granted_role;

SELECT a.grantee,
       a.granted_role,
       a.admin_option,
       a.default_role
FROM   dba_role_privs a
WHERE  a.grantee = DECODE(UPPER('&1'), 'ALL', a.grantee, UPPER('&1'))
ORDER BY a.grantee, a.granted_role;

SELECT a.role,
       a.privilege,
       a.admin_option
FROM   role_sys_privs a
WHERE  a.role = DECODE(UPPER('&1'), 'ALL', a.role, UPPER('&1'))
ORDER BY a.role, a.privilege;

SELECT a.role,
       a.owner,
       a.table_name, 
       a.column_name, 
       a.privilege,
       a.grantable
FROM   role_tab_privs a
WHERE  a.role = DECODE(UPPER('&1'), 'ALL', a.role, UPPER('&1'))
ORDER BY a.role, a.owner, a.table_name;
               
SET VERIFY ON
