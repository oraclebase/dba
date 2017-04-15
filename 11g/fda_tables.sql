-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/11g/fda_tables.sql
-- Author       : Tim Hall
-- Description  : Displays information about flashback data archives.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @fda_tables
-- Last Modified: 06-JAN-2015
-- -----------------------------------------------------------------------------------

SET LINESIZE 150

COLUMN owner_name FORMAT A20
COLUMN table_name FORMAT A20
COLUMN flashback_archive_name FORMAT A22
COLUMN archive_table_name FORMAT A20

SELECT owner_name,
       table_name,
       flashback_archive_name,
       archive_table_name,
       status
FROM   dba_flashback_archive_tables
ORDER BY owner_name, table_name;
