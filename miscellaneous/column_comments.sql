-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/miscellaneous/column_comments.sql
-- Author       : Tim Hall
-- Description  : Displays comments associate with specific tables.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @column_comments (schema) (table-name)
-- Last Modified: 15/07/2000
-- -----------------------------------------------------------------------------------
SET VERIFY OFF
SET PAGESIZE 100
COLUMN column_name FORMAT A20
COLUMN comments    FORMAT A50

SELECT column_name,
       comments
FROM   dba_col_comments
WHERE  owner      = UPPER('&1')
AND    table_name = UPPER('&2')
ORDER BY column_name;
