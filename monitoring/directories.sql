-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/directories.sql
-- Author       : Tim Hall
-- Description  : Displays information about all directories.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @directories
-- Last Modified: 04/10/2006
-- -----------------------------------------------------------------------------------
SET LINESIZE 150

COLUMN owner FORMAT A20
COLUMN directory_name FORMAT A25
COLUMN directory_path FORMAT A80

SELECT *
FROM   dba_directories
ORDER BY owner, directory_name;
