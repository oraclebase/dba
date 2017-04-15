-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/hot_blocks.sql
-- Author       : Tim Hall
-- Description  : Detects hot blocks.
-- Call Syntax  : @hot_blocks
-- Last Modified: 17/02/2005
-- -----------------------------------------------------------------------------------
SET LINESIZE 200
SET VERIFY OFF

SELECT *
FROM   (SELECT name,
               addr,
               gets,
               misses,
               sleeps
        FROM   v$latch_children
        WHERE  name = 'cache buffers chains'
        AND    misses > 0
        ORDER BY misses DESC)
WHERE  rownum < 11;

ACCEPT address PROMPT "Enter ADDR: "

COLUMN owner FORMAT A15
COLUMN object_name FORMAT A30
COLUMN subobject_name FORMAT A20

SELECT *
FROM   (SELECT o.owner,
               o.object_name,
               o.subobject_name,
               bh.tch,
               bh.obj,
               bh.file#,
               bh.dbablk,
               bh.class,
               bh.state
        FROM   x$bh bh,
               dba_objects o
        WHERE  o.data_object_id = bh.obj
        AND    hladdr = '&address'
        ORDER BY tch DESC)
WHERE  rownum < 11;
