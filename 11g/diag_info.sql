-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/11g/diag_info.sql
-- Author       : Tim Hall
-- Description  : Displays the contents of the v$diag_info view.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @diag_info
-- Last Modified: 23/08/2008
-- -----------------------------------------------------------------------------------
SET LINESIZE 200
COLUMN name FORMAT A30
COLUMN value FORMAT A110

SELECT *
FROM   v$diag_info;
