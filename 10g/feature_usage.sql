-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/10g/feature_usage.sql
-- Author       : Tim Hall
-- Description  : Displays feature usage statistics.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @feature_usage
-- Last Modified: 26-NOV-2004
-- -----------------------------------------------------------------------------------

COLUMN name  FORMAT A60
COLUMN detected_usages FORMAT 999999999999

SELECT u1.name,
       u1.detected_usages,
       u1.currently_used,
       u1.version
FROM   dba_feature_usage_statistics u1
WHERE  u1.version = (SELECT MAX(u2.version)
                     FROM   dba_feature_usage_statistics u2
                     WHERE  u2.name = u1.name)
AND    u1.detected_usages > 0
AND    u1.dbid = (SELECT dbid FROM v$database)
ORDER BY u1.name;

COLUMN FORMAT DEFAULT