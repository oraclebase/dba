-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/objects.sql
-- Author       : Tim Hall
-- Description  : Displays information about all database objects.
-- Requirements : Access to the dba_objects view.
-- Call Syntax  : @objects [ object-name | % (for all)]
-- Last Modified: 21-FEB-2005
-- -----------------------------------------------------------------------------------
SET LINESIZE 200 VERIFY OFF

COLUMN owner FORMAT A20
COLUMN object_name FORMAT A30
COLUMN edition_name FORMAT A15

SELECT owner,
       object_name,
       --subobject_name,
       object_id,
       data_object_id,
       object_type,
       TO_CHAR(created, 'DD-MON-YYYY HH24:MI:SS') AS created,
       TO_CHAR(last_ddl_time, 'DD-MON-YYYY HH24:MI:SS') AS last_ddl_time,
       timestamp,
       status,
       temporary,
       generated,
       secondary,
       --namespace,
       edition_name
FROM   dba_objects
WHERE  UPPER(object_name) LIKE UPPER('%&1%')
ORDER BY owner, object_name;

SET VERIFY ON
