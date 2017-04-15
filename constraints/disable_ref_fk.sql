-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/constraints/disable_ref_fk.sql
-- Author       : Tim Hall
-- Description  : Disables all Foreign Keys referencing a specified table, or all tables.
-- Call Syntax  : @disable_ref_fk (table-name) (schema-name)
-- Last Modified: 28/01/2001
-- -----------------------------------------------------------------------------------
SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF

SPOOL temp.sql

SELECT 'ALTER TABLE "' || a.table_name || '" DISABLE CONSTRAINT "' || a.constraint_name || '";' enable_constraints
FROM   all_constraints a
WHERE  a.owner      = Upper('&2')
AND    a.constraint_type = 'R'
AND    a.r_constraint_name IN (SELECT a1.constraint_name
                               FROM   all_constraints a1
                               WHERE  a1.table_name = DECODE(Upper('&1'),'ALL',a.table_name,Upper('&1'))
                               AND    a1.owner      = Upper('&2'));

SPOOL OFF

-- Comment out following line to prevent immediate run
@temp.sql

SET PAGESIZE 14
SET FEEDBACK ON
SET VERIFY ON
