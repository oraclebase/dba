-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/pipes.sql
-- Author       : Tim Hall
-- Description  : Displays a list of all database pipes.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @pipes
-- Last Modified: 15/07/2000
-- -----------------------------------------------------------------------------------
SET LINESIZE 100

COLUMN name FORMAT A40

SELECT ownerid,
       name,
       type,
       pipe_size
FROM   v$db_pipes
ORDER BY 1,2;

