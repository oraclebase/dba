-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/12c/priv_captures.sql
-- Author       : Tim Hall
-- Description  : Displays privilege capture policies.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @priv_captures.sql
-- Last Modified: 22-APR-2014
-- -----------------------------------------------------------------------------------

COLUMN name FORMAT A15
COLUMN description FORMAT A30
COLUMN roles FORMAT A20
COLUMN context FORMAT A30
SET LINESIZE 200

SELECT name,
       description,
       type,
       enabled,
       roles,
       context
FROM   dba_priv_captures
ORDER BY name;