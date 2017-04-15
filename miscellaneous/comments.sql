-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/miscellaneous/comments.sql
-- Author       : Tim Hall
-- Description  : Displays all comments for the specified table and its columns.
-- Call Syntax  : @comments (table-name) (schema-name)
-- Last Modified: 15/07/2000
-- -----------------------------------------------------------------------------------
PROMPT
SET VERIFY OFF
SET FEEDBACK OFF
SET LINESIZE 255
SET PAGESIZE 1000

SELECT a.table_name "Table",
       a.table_type "Type",
       Substr(a.comments,1,200) "Comments"
FROM   all_tab_comments a
WHERE  a.table_name = Upper('&1')
AND    a.owner      = Upper('&2');

SELECT a.column_name "Column",
       Substr(a.comments,1,200) "Comments"
FROM   all_col_comments a
WHERE  a.table_name = Upper('&1')
AND    a.owner      = Upper('&2');

SET VERIFY ON
SET FEEDBACK ON
SET PAGESIZE 14
PROMPT
