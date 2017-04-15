-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/lru_latch_ratio.sql
-- Author       : Tim Hall
-- Description  : Displays current LRU latch ratios.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @lru_latch_hit_ratio
-- Last Modified: 15/07/2000
-- -----------------------------------------------------------------------------------
SET LINESIZE 500
SET PAGESIZE 1000
COLUMN "Ratio %" FORMAT 990.00
 
PROMPT
PROMPT Values greater than 3% indicate contention.

SELECT a.child#,
       (a.SLEEPS / a.GETS) * 100 "Ratio %"
FROM   v$latch_children a
WHERE  a.name      = 'cache buffers lru chain'
ORDER BY 1;


SET PAGESIZE 14
