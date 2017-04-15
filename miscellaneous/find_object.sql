-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/miscellaneous/find_object.sql
-- Author       : Tim Hall
-- Description  : Lists all objects with a similar name to that specified.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @find_object (object-name)
-- Last Modified: 26-JUL-2016
-- -----------------------------------------------------------------------------------

SET VERIFY OFF LINESIZE 200

COLUMN object_name FORMAT A30
COLUMN owner FORMAT A20

SELECT object_name, owner, object_type, status
FROM   dba_objects
WHERE  LOWER(object_name) LIKE '%' || LOWER('&1') || '%'
ORDER BY 1, 2, 3;
