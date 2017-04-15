-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/security/sequence_synonyms.sql
-- Author       : Tim Hall
-- Description  : Creates synonyms in the current schema for all sequences in the specified schema.
-- Call Syntax  : @sequence_synonyms (schema-name)
-- Last Modified: 28/01/2001
-- -----------------------------------------------------------------------------------
SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF

SPOOL temp.sql

SELECT 'CREATE SYNONYM "' || a.object_name || '" FOR "' || a.owner || '"."' || a.object_name || '";'
FROM   all_objects a
WHERE  a.object_type = 'SEQUENCE'
AND    a.owner       = UPPER('&1')
AND    NOT EXISTS (SELECT '1'
                   FROM   user_synonyms a1
                   WHERE  a1.synonym_name = a.object_name
                   AND    a1.table_owner  = UPPER('&1'));


SPOOL OFF

-- Comment out following line to prevent immediate run
@temp.sql

SET PAGESIZE 14
SET FEEDBACK ON
SET VERIFY ON
