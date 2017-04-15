-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/rbs_extents.sql
-- Author       : Tim Hall
-- Description  : Displays information about the rollback segment extents.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @rbs_extents
-- Last Modified: 15/07/2000
-- -----------------------------------------------------------------------------------
SET LINESIZE 500
SET PAGESIZE 1000
SET VERIFY OFF

SELECT Substr(a.segment_name,1,30) "Segment Name",
       b.status "Status",
       Count(*) "Extents",
       b.max_extents "Max Extents",
       Trunc(b.initial_extent/1024) "Initial Extent (Kb)",
       Trunc(b.next_extent/1024) "Next Extent (Kb)",
       Trunc(c.bytes/1024) "Size (Kb)"
FROM   dba_extents a,
       dba_rollback_segs b,
       dba_segments c
WHERE  a.segment_type = 'ROLLBACK'
AND    b.segment_name = a.segment_name
AND    b.segment_name = c.segment_name
GROUP  BY a.segment_name,
          b.status, 
          b.max_extents,
          b.initial_extent,
          b.next_extent,
          c.bytes
ORDER  BY a.segment_name;

SET PAGESIZE 14
SET VERIFY ON