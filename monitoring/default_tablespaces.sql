-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/default_tablespaces.sql
-- Author       : Tim Hall
-- Description  : Displays the default temporary and permanent tablespaces.
-- Requirements : Access to the DATABASE_PROPERTIES views.
-- Call Syntax  : @default_tablespaces
-- Last Modified: 04/06/2019
-- -----------------------------------------------------------------------------------
COLUMN property_name FORMAT A30
COLUMN property_value FORMAT A30
COLUMN description FORMAT A50
SET LINESIZE 200

SELECT *
FROM   database_properties
WHERE  property_name like '%TABLESPACE';
