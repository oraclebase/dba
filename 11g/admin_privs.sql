-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/11g/admin_privs.sql
-- Author       : Tim Hall
-- Description  : Displays the users who currently have admin privileges.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @min_datafile_size
-- Last Modified: 30/11/2011
-- -----------------------------------------------------------------------------------

SELECT *
FROM   v$pwfile_users
ORDER BY username;