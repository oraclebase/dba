-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/user_system_privs.sql
-- Author       : Tim Hall
-- Description  : Displays system privileges granted to a specified user.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @user_system_privs (user-name)
-- Last Modified: 27/07/2005
-- -----------------------------------------------------------------------------------
SET LINESIZE 200 VERIFY OFF

SELECT grantee,
       privilege,
       admin_option
FROM   dba_sys_privs
WHERE  grantee = UPPER('&1')
ORDER BY grantee, privilege;

SET VERIFY ON