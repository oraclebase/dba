-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/miscellaneous/analyze_all.sql
-- Author       : Tim Hall
-- Description  : Outdated script to analyze all tables for the specified schema.
-- Comment      : Use DBMS_UTILITY.ANALYZE_SCHEMA or DBMS_STATS.GATHER_SCHEMA_STATS if your server allows it.
-- Call Syntax  : @ananlyze_all (schema-name)
-- Last Modified: 26/02/2002
-- -----------------------------------------------------------------------------------
SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF

SPOOL temp.sql

SELECT 'ANALYZE TABLE "' || table_name || '" COMPUTE STATISTICS;'
FROM   all_tables
WHERE  owner = Upper('&1')
ORDER BY 1;

SPOOL OFF

-- Comment out following line to prevent immediate run
@temp.sql

SET PAGESIZE 14
SET FEEDBACK ON
SET VERIFY ON
