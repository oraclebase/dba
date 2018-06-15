-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/segments_in_ts.sql
-- Author       : Tim Hall
-- Description  : Lists the objects stored in a tablespace.
-- Call Syntax  : @objects_in_ts (tablespace-name)
-- Last Modified: 15/06/2018
-- -----------------------------------------------------------------------------------

SET PAGESIZE 20
BREAK ON segment_type SKIP 1

COLUMN segment_name FORMAT A30
COLUMN partition_name FORMAT A30

SELECT segment_type,
       segment_name,
       partition_name,
       ROUND(bytes/2014/1024,2) AS size_mb
FROM   dba_segments
WHERE  tablespace_name = UPPER('&1')
ORDER BY 1, 2;

CLEAR BREAKS
