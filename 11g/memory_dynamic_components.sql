-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/11g/memory_dynamic_components.sql
-- Author       : Tim Hall
-- Description  : Provides information about dynamic memory components.
-- Requirements : Access to the v$ views.
-- Call Syntax  : @memory_dynamic_components
-- Last Modified: 09/05/2017
-- -----------------------------------------------------------------------------------
COLUMN component FORMAT A30

SELECT  component,
        ROUND(current_size/1024/1024) AS current_size_mb,
        ROUND(min_size/1024/1024) AS min_size_mb,
        ROUND(max_size/1024/1024) AS max_size_mb
FROM    v$memory_dynamic_components
WHERE   current_size != 0
ORDER BY component;
