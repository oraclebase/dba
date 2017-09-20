-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/users_with_sys_priv.sql
-- Author       : Tim Hall
-- Description  : Displays a list of users granted the specified role.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @users_with_sys_priv "UNLIMITED TABLESPACE"
-- Last Modified: 15/07/2000
-- -----------------------------------------------------------------------------------

SET VERIFY OFF
COLUMN username FORMAT A30

SELECT username,
       lock_date,
       expiry_date
FROM   dba_users
WHERE  username IN (SELECT grantee
                    FROM   dba_sys_privs
                    WHERE  privilege = UPPER('&1'))
ORDER BY username;
