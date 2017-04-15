-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/security/grant_execute.sql
-- Author       : Tim Hall
-- Description  : Grants execute on current schemas code objects to the specified user/role.
-- Call Syntax  : @grant_execute (schema-name)
-- Last Modified: 28/01/2001
-- -----------------------------------------------------------------------------------
SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF

SPOOL temp.sql

SELECT 'GRANT EXECUTE ON "' || u.object_name || '" TO &1;'
FROM   user_objects u
WHERE  u.object_type IN ('PACKAGE','PROCEDURE','FUNCTION')
AND    NOT EXISTS (SELECT '1'
                   FROM   all_tab_privs a
                   WHERE  a.grantee    = UPPER('&1')
                   AND    a.privilege  = 'EXECUTE'
                   AND    a.table_name = u.object_name);

SPOOL OFF

-- Comment out following line to prevent immediate run
@temp.sql

SET PAGESIZE 14
SET FEEDBACK ON
SET VERIFY ON
