-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/constraints/enable_chk.sql
-- Author       : Tim Hall
-- Description  : Enables all check constraints for a specified table, or all tables.
-- Call Syntax  : @enable_chk (table-name or all) (schema-name)
-- Last Modified: 28/01/2001
-- -----------------------------------------------------------------------------------
SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF

SPOOL temp.sql

SELECT 'ALTER TABLE "' || a.table_name || '" ENABLE CONSTRAINT "' || a.constraint_name || '";'
FROM   all_constraints a
WHERE  a.constraint_type = 'C'
AND    a.owner           = Upper('&2');
AND    a.table_name      = DECODE(Upper('&1'),'ALL',a.table_name,UPPER('&1'));

SPOOL OFF

-- Comment out following line to prevent immediate run
@temp.sql

SET PAGESIZE 14
SET FEEDBACK ON
SET VERIFY ON
