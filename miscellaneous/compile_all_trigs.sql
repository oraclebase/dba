-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/miscellaneous/compile_all_trigs.sql
-- Author       : Tim Hall
-- Description  : Compiles all invalid triggers for specified schema, or all schema.
-- Call Syntax  : @compile_all_trigs (schema-name or all)
-- Last Modified: 28/01/2001
-- -----------------------------------------------------------------------------------
SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF

SPOOL temp.sql

SELECT 'ALTER TRIGGER ' || a.owner || '.' || a.object_name || ' COMPILE;'
FROM    all_objects a
WHERE   a.object_type = 'TRIGGER'
AND     a.status      = 'INVALID'
AND     a.owner       = Decode(Upper('&&1'), 'ALL',a.owner, Upper('&&1'));

SPOOL OFF

-- Comment out following line to prevent immediate run
@temp.sql

SET PAGESIZE 14
SET FEEDBACK ON
SET VERIFY ON
