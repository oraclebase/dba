-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/system_privs.sql
-- Author       : Tim Hall
-- Description  : Displays users granted the specified system privilege.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @system_privs ("sys-priv")
-- Last Modified: 27/07/2005
-- -----------------------------------------------------------------------------------
SET LINESIZE 200 VERIFY OFF

SELECT privilege,
       grantee,
       admin_option
FROM   dba_sys_privs
WHERE  privilege LIKE UPPER('%&1%')
ORDER BY privilege, grantee;

SET VERIFY ON