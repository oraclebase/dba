-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/security/grant_insert.sql
-- Author       : Tim Hall
-- Description  : Grants insert on current schemas tables to the specified user/role.
-- Call Syntax  : @grant_insert (schema-name)
-- Last Modified: 28/01/2001
-- -----------------------------------------------------------------------------------
SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF

SPOOL temp.sql

SELECT 'GRANT INSERT ON "' || u.table_name || '" TO &1;'
FROM   user_tables u
WHERE  NOT EXISTS (SELECT '1'
                   FROM   all_tab_privs a
                   WHERE  a.grantee    = UPPER('&1')
                   AND    a.privilege  = 'INSERT'
                   AND    a.table_name = u.table_name);

SPOOL OFF

-- Comment out following line to prevent immediate run
@temp.sql

SET PAGESIZE 14
SET FEEDBACK ON
SET VERIFY ON
