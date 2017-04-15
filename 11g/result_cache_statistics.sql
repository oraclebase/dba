-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/11g/result_cache_statistics.sql
-- Author       : Tim Hall
-- Description  : Displays result cache statistics.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @result_cache_statistics
-- Last Modified: 07/11/2012
-- -----------------------------------------------------------------------------------

COLUMN name FORMAT A30
COLUMN value FORMAT A30

SELECT id,
       name,
       value
FROM   v$result_cache_statistics
ORDER BY id;

CLEAR COLUMNS