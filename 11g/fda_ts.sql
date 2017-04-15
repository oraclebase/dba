-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/11g/fda_ts.sql
-- Author       : Tim Hall
-- Description  : Displays information about flashback data archives.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @fda_ts
-- Last Modified: 06-JAN-2015
-- -----------------------------------------------------------------------------------

SET LINESIZE 150

COLUMN flashback_archive_name FORMAT A22
COLUMN tablespace_name FORMAT A20
COLUMN quota_in_mb FORMAT A11

SELECT flashback_archive_name,
       flashback_archive#,
       tablespace_name,
       quota_in_mb
FROM   dba_flashback_archive_ts
ORDER BY flashback_archive_name;
