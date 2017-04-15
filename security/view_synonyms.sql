-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/security/view_synonyms.sql
-- Author       : Tim Hall
-- Description  : Creates synonyms in the current schema for all views in the specified schema.
-- Call Syntax  : @view_synonyms (schema-name)
-- Last Modified: 28/01/2001
-- -----------------------------------------------------------------------------------
SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF

SPOOL temp.sql

SELECT 'CREATE SYNONYM "' || a.view_name || '" FOR "' || a.owner || '"."' || a.view_name || '";'
FROM   all_views a
WHERE  a.owner = UPPER('&1')
AND    NOT EXISTS (SELECT '1'
                   FROM   user_synonyms u
                   WHERE  u.synonym_name = a.view_name
                   AND    u.table_owner  = UPPER('&1'));

SPOOL OFF

-- Comment out following line to prevent immediate run
@temp.sql

SET PAGESIZE 14
SET FEEDBACK ON
SET VERIFY ON
