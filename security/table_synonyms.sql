-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/security/table_synonyms.sql
-- Author       : Tim Hall
-- Description  : Creates synonyms in the current schema for all tables in the specified schema.
-- Call Syntax  : @table_synonyms (schema-name)
-- Last Modified: 28/01/2001
-- -----------------------------------------------------------------------------------
SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF

SPOOL temp.sql

SELECT 'CREATE SYNONYM "' || a.table_name || '" FOR "' || a.owner || '"."' || a.table_name || '";'
FROM   all_tables a
WHERE  NOT EXISTS (SELECT '1'
                   FROM   user_synonyms u
                   WHERE  u.synonym_name = a.table_name
                   AND    u.table_owner  = UPPER('&1'))
AND    a.owner = UPPER('&1');

SPOOL OFF

-- Comment out following line to prevent immediate run
@temp.sql

SET PAGESIZE 14
SET FEEDBACK ON
SET VERIFY ON
