-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/miscellaneous/dict_comments.sql
-- Author       : Tim Hall
-- Description  : Displays comments associate with specific tables.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @dict_comments (table-name or partial match)
-- Last Modified: 15/07/2000
-- -----------------------------------------------------------------------------------
PROMPT
SET VERIFY OFF
SET FEEDBACK OFF
SET LINESIZE 255
SET PAGESIZE 1000

SELECT a.table_name "Table",
       Substr(a.comments,1,200) "Comments"
FROM   dictionary a
WHERE  a.table_name LIKE Upper('%&1%');

SET VERIFY ON
SET FEEDBACK ON
SET PAGESIZE 14
PROMPT
