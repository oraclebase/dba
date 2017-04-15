-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/constraints/disable_fk.sql
-- Author       : Tim Hall
-- Description  : Disables all Foreign Keys belonging to the specified table, or all tables.
-- Call Syntax  : @disable_fk (table-name or all) (schema-name)
-- Last Modified: 28/01/2001
-- -----------------------------------------------------------------------------------
SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF

SPOOL temp.sql

SELECT 'ALTER TABLE "' || a.table_name || '" DISABLE CONSTRAINT "' || a.constraint_name || '";'
FROM   all_constraints a
WHERE  a.constraint_type = 'R'
AND    a.table_name      = DECODE(Upper('&1'),'ALL',a.table_name,Upper('&1'))
AND    a.owner           = Upper('&2');

SPOOL OFF

-- Comment out following line to prevent immediate run
@temp.sql

SET PAGESIZE 14
SET FEEDBACK ON
SET VERIFY ON
