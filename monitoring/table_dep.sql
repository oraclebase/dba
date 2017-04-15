-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/table_dep.sql
-- Author       : Tim Hall
-- Description  : Displays a list dependencies for the specified table.
-- Requirements : Access to the ALL views.
-- Call Syntax  : @table_dep (table-name) (schema-name)
-- Last Modified: 15/07/2000
-- -----------------------------------------------------------------------------------
PROMPT
SET VERIFY OFF
SET FEEDBACK OFF
SET LINESIZE 255
SET PAGESIZE 1000


SELECT ad.referenced_name "Object",
       ad.name "Ref Object",
       ad.type "Type",
       Substr(ad.referenced_owner,1,10) "Ref Owner",
       Substr(ad.referenced_link_name,1,20) "Ref Link Name"
FROM   all_dependencies ad
WHERE  ad.referenced_name = Upper('&&1')
AND    ad.owner           = Upper('&&2')
ORDER BY 1,2,3;

SET VERIFY ON
SET FEEDBACK ON
SET PAGESIZE 14
PROMPT
