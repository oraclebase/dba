-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/controlfiles.sql
-- Author       : Tim Hall
-- Description  : Displays information about controlfiles.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @controlfiles
-- Last Modified: 21/12/2004
-- -----------------------------------------------------------------------------------

SET LINESIZE 100
COLUMN name FORMAT A80

SELECT name,
       status
FROM   v$controlfile
ORDER BY name;

SET LINESIZE 80