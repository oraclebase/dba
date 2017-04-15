-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/miscellaneous/proc_defs.sql
-- Author       : Tim Hall
-- Description  : Lists the parameters for the specified package and procedure.
-- Call Syntax  : @proc_defs (package-name) (procedure-name or all)
-- Last Modified: 24/09/2003
-- -----------------------------------------------------------------------------------
COLUMN "Object Name" FORMAT A30
COLUMN ol FORMAT A2
COLUMN sq FORMAT 99
COLUMN "Argument Name" FORMAT A32
COLUMN "Type" FORMAT A15
COLUMN "Size" FORMAT A6
BREAK ON ol SKIP 2
SET PAGESIZE 0
SET LINESIZE 200
SET TRIMOUT ON
SET TRIMSPOOL ON
SET VERIFY OFF

SELECT object_name AS "Object Name",
       overload AS ol,
       sequence AS sq,
       RPAD(' ', data_level*2, ' ') || argument_name AS "Argument Name",
       data_type AS "Type",
       (CASE
         WHEN data_type IN ('VARCHAR2','CHAR') THEN TO_CHAR(data_length)
         WHEN data_scale IS NULL OR data_scale = 0 THEN TO_CHAR(data_precision)
         ELSE TO_CHAR(data_precision) || ',' || TO_CHAR(data_scale)
       END) "Size",
       in_out AS "In/Out",
       default_value
FROM   user_arguments
WHERE  package_name = UPPER('&1')
AND    object_name  = DECODE(UPPER('&2'), 'ALL', object_name, UPPER('&2'))
ORDER BY object_name, overload, sequence;

SET PAGESIZE 14
SET LINESIZE 80
