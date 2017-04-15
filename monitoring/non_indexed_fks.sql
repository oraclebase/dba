-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/non_indexed_fks.sql
-- Author       : Tim Hall
-- Description  : Displays a list of non-indexes FKs.
-- Requirements : Access to the ALL views.
-- Call Syntax  : @non_indexed_fks
-- Last Modified: 15/07/2000
-- -----------------------------------------------------------------------------------
SET SERVEROUTPUT ON
SET PAGESIZE 1000
SET LINESIZE 255
SET FEEDBACK OFF

SELECT t.table_name,
       c.constraint_name,
       c.table_name table2,
       acc.column_name
FROM   all_constraints t,
       all_constraints c,
       all_cons_columns acc
WHERE  c.r_constraint_name = t.constraint_name
AND    c.table_name        = acc.table_name
AND    c.constraint_name   = acc.constraint_name
AND    NOT EXISTS (SELECT '1' 
                   FROM  all_ind_columns aid
                   WHERE aid.table_name  = acc.table_name
                   AND   aid.column_name = acc.column_name)
ORDER BY c.table_name;


PROMPT
SET FEEDBACK ON
SET PAGESIZE 18
