-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/segment_size.sql
-- Author       : Tim Hall
-- Description  : Displays size of specified segment.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @segment_size (owner) (segment_name)
-- Last Modified: 15/07/2005
-- -----------------------------------------------------------------------------------
SET LINESIZE 500 VERIFY OFF
COLUMN segment_name FORMAT A30

SELECT owner,
       segment_name,
       segment_type,
       tablespace_name,
       ROUND(bytes/1024/1024,2) size_mb
FROM   dba_segments
WHERE  owner = UPPER('&1')
AND    segment_name LIKE '%' || UPPER('&2') || '%'
ORDER BY 1, 2;

SET VERIFY ON