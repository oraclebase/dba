-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/large_lob_segments.sql
-- Author       : Tim Hall
-- Description  : Displays size of large LOB segments.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @large_lob_segments (rows)
-- Last Modified: 12/09/2017
-- -----------------------------------------------------------------------------------
SET LINESIZE 500 VERIFY OFF
COLUMN owner FORMAT A30
COLUMN table_name FORMAT A30
COLUMN column_name FORMAT A30
COLUMN segment_name FORMAT A30
COLUMN tablespace_name FORMAT A30
COLUMN size_mb FORMAT 99999999.00

SELECT *
FROM   (SELECT l.owner,
               l.table_name,
               l.column_name,
               l.segment_name,
               l.tablespace_name,
               ROUND(s.bytes/1024/1024,2) size_mb
        FROM   dba_lobs l
               JOIN dba_segments s ON s.owner = l.owner AND s.segment_name = l.segment_name
        ORDER BY 6 DESC)
WHERE  ROWNUM <= &1;

SET VERIFY ON