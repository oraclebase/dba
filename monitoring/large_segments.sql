-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/large_segments.sql
-- Author       : Tim Hall
-- Description  : Displays size of large segments.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @large_segments (rows)
-- Last Modified: 12/09/2017
-- -----------------------------------------------------------------------------------
SET LINESIZE 500 VERIFY OFF
COLUMN owner FORMAT A30
COLUMN segment_name FORMAT A30
COLUMN tablespace_name FORMAT A30
COLUMN size_mb FORMAT 99999999.00

SELECT *
FROM   (SELECT owner,
               segment_name,
               segment_type,
               tablespace_name,
               ROUND(bytes/1024/1024,2) size_mb
        FROM   dba_segments
        ORDER BY 5 DESC)
WHERE  ROWNUM <= &1;

SET VERIFY ON