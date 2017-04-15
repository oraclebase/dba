-- -----------------------------------------------------------------------------------
-- File Name    : http://www.oracle-base.com/dba/monitoring/fk_columns.sql
-- Author       : DR Timothy S Hall
-- Description  : Displays information on all FKs for the specified schema and table.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @fk_columns (schema-name or all) (table-name or all)
-- Last Modified: 22/09/2005
-- -----------------------------------------------------------------------------------
SET VERIFY OFF
SET LINESIZE 1000
COLUMN column_name FORMAT A30
COLUMN r_column_name FORMAT A30

SELECT c.constraint_name,
       cc.table_name,
       cc.column_name,
       rcc.table_name AS r_table_name,
       rcc.column_name AS r_column_name,
       cc.position
FROM   dba_constraints c
       JOIN dba_cons_columns cc ON c.owner = cc.owner AND c.constraint_name = cc.constraint_name
       JOIN dba_cons_columns rcc ON c.owner = rcc.owner AND c.r_constraint_name = rcc.constraint_name AND cc.position = rcc.position
WHERE  c.owner      = DECODE(UPPER('&1'), 'ALL', c.owner, UPPER('&1'))
AND    c.table_name = DECODE(UPPER('&2'), 'ALL', c.table_name, UPPER('&2'))
ORDER BY c.constraint_name, cc.table_name, cc.position;
