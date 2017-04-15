-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/12c/redaction_value_defaults.sql
-- Author       : Tim Hall
-- Description  : Displays information about redaction defaults.
-- Requirements : Access to the REDACTION_VALUES_FOR_TYPE_FULL view.
-- Call Syntax  : @redaction_value_defaults
-- Last Modified: 27-NOV-2014
-- -----------------------------------------------------------------------------------

SET LINESIZE 250
COLUMN char_value FORMAT A10
COLUMN varchar_value FORMAT A10
COLUMN nchar_value FORMAT A10
COLUMN nvarchar_value FORMAT A10
COLUMN timestamp_value FORMAT A27
COLUMN timestamp_with_time_zone_value FORMAT A32
COLUMN blob_value FORMAT A20
COLUMN clob_value FORMAT A10
COLUMN nclob_value FORMAT A10

SELECT *
FROM   redaction_values_for_type_full;
