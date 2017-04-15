-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/column_defaults.sql
-- Author       : Tim Hall
-- Description  : Displays the default values where present for the specified table.
-- Call Syntax  : @column_defaults (table-name)
-- Last Modified: 15/07/2000
-- -----------------------------------------------------------------------------------
SET LINESIZE 100
SET VERIFY OFF

SELECT a.column_name "Column",
       a.data_default "Default"
FROM   all_tab_columns a
WHERE  a.table_name = Upper('&1')
AND    a.data_default IS NOT NULL
/