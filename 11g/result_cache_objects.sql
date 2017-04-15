-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/11g/result_cache_objects.sql
-- Author       : Tim Hall
-- Description  : Displays information about the objects in the result cache.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @result_cache_objects
-- Last Modified: 07/11/2012
-- -----------------------------------------------------------------------------------
SET LINESIZE 1000

SELECT *
FROM v$result_cache_objects;
