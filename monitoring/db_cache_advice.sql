-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/db_cache_advice.sql
-- Author       : Tim Hall
-- Description  : Predicts how changes to the buffer cache will affect physical reads.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @db_cache_advice
-- Last Modified: 12/02/2004
-- -----------------------------------------------------------------------------------

COLUMN size_for_estimate          FORMAT 999,999,999,999 heading 'Cache Size (MB)'
COLUMN buffers_for_estimate       FORMAT 999,999,999 heading 'Buffers'
COLUMN estd_physical_read_factor  FORMAT 999.90 heading 'Estd Phys|Read Factor'
COLUMN estd_physical_reads        FORMAT 999,999,999,999 heading 'Estd Phys| Reads'

SELECT size_for_estimate, 
       buffers_for_estimate,
       estd_physical_read_factor,
       estd_physical_reads
FROM   v$db_cache_advice
WHERE  name          = 'DEFAULT'
AND    block_size    = (SELECT value
                        FROM   v$parameter
                        WHERE  name = 'db_block_size')
AND    advice_status = 'ON';
