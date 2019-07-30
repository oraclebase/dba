-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/19c/auto_index_config.sql
-- Author       : Tim Hall
-- Description  : Displays the auto-index configuration for each container.
-- Requirements : Access to the CDB views.
-- Call Syntax  : @auto_index_config
-- Last Modified: 04/06/2019
-- -----------------------------------------------------------------------------------
COLUMN parameter_name FORMAT A40
COLUMN parameter_value FORMAT A40

SELECT con_id, parameter_name, parameter_value 
FROM   cdb_auto_index_config
ORDER BY 1, 2;
