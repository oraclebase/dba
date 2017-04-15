-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/roles.sql
-- Author       : Tim Hall
-- Description  : Displays a list of all roles and privileges granted to the specified user.
-- Requirements : Access to the USER views.
-- Call Syntax  : @roles
-- Last Modified: 15/07/2000
-- -----------------------------------------------------------------------------------
SET SERVEROUTPUT ON
SET VERIFY OFF

SELECT a.role,
       a.password_required,
       a.authentication_type
FROM   dba_roles a
ORDER BY a.role;
               
SET VERIFY ON
