-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/object_status.sql
-- Author       : Tim Hall
-- Description  : Displays a list of objects and their status for the specific schema.
-- Requirements : Access to the ALL views.
-- Call Syntax  : @object_status (schema-name)
-- Last Modified: 15/07/2000
-- -----------------------------------------------------------------------------------
SET SERVEROUTPUT ON
SET PAGESIZE 1000
SET LINESIZE 255
SET FEEDBACK OFF
SET VERIFY OFF

SELECT Substr(object_name,1,30) object_name,
       object_type,
       status
FROM   all_objects
WHERE  owner = Upper('&&1');

PROMPT
SET FEEDBACK ON
SET PAGESIZE 18
