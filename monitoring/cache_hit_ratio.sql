-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/cache_hit_ratio.sql
-- Author       : Tim Hall
-- Description  : Displays cache hit ratio for the database.
-- Comments     : The minimum figure of 89% is often quoted, but depending on the type of system this may not be possible.
-- Requirements : Access to the v$ views.
-- Call Syntax  : @cache_hit_ratio
-- Last Modified: 15/07/2000
-- -----------------------------------------------------------------------------------
PROMPT
PROMPT Hit ratio should exceed 89%

SELECT Sum(Decode(a.name, 'consistent gets', a.value, 0)) "Consistent Gets",
       Sum(Decode(a.name, 'db block gets', a.value, 0)) "DB Block Gets",
       Sum(Decode(a.name, 'physical reads', a.value, 0)) "Physical Reads",
       Round(((Sum(Decode(a.name, 'consistent gets', a.value, 0)) +
         Sum(Decode(a.name, 'db block gets', a.value, 0)) -
         Sum(Decode(a.name, 'physical reads', a.value, 0))  )/
           (Sum(Decode(a.name, 'consistent gets', a.value, 0)) +
             Sum(Decode(a.name, 'db block gets', a.value, 0))))
             *100,2) "Hit Ratio %"
FROM   v$sysstat a;
