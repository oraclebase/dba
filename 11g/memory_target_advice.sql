-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/11g/memory_target_advice.sql
-- Author       : Tim Hall
-- Description  : Provides information to help tune the MEMORY_TARGET parameter.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @memory_target_advice
-- Last Modified: 23/08/2008
-- -----------------------------------------------------------------------------------
SELECT *
FROM   v$memory_target_advice
ORDER BY memory_size;