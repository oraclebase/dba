-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/latch_hit_ratios.sql
-- Author       : Tim Hall
-- Description  : Displays current latch hit ratios.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @latch_hit_ratios
-- Last Modified: 15-JUL-2000
-- -----------------------------------------------------------------------------------
SET LINESIZE 200

COLUMN latch_hit_ratio FORMAT 990.00
 
SELECT l.name,
       l.gets,
       l.misses,
       ((1 - (l.misses / l.gets)) * 100) AS latch_hit_ratio
FROM   v$latch l
WHERE  l.gets   != 0
UNION
SELECT l.name,
       l.gets,
       l.misses,
       100 AS latch_hit_ratio
FROM   v$latch l
WHERE  l.gets   = 0
ORDER BY 4 DESC;
