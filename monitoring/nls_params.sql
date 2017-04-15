-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/nls_params.sql
-- Author       : Tim Hall
-- Description  : Displays National Language Suppport (NLS) information.
-- Requirements : 
-- Call Syntax  : @nls_params
-- Last Modified: 21-FEB-2005
-- -----------------------------------------------------------------------------------
SET LINESIZE 100
COLUMN parameter FORMAT A45
COLUMN value FORMAT A45

PROMPT *** Database parameters ***
SELECT * FROM nls_database_parameters ORDER BY 1;

PROMPT *** Instance parameters ***
SELECT * FROM nls_instance_parameters ORDER BY 1;

PROMPT *** Session parameters ***
SELECT * FROM nls_session_parameters ORDER BY 1;