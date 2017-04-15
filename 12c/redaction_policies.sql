-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/12c/redaction_policies.sql
-- Author       : Tim Hall
-- Description  : Displays redaction policy information.
-- Requirements : Access to the REDACTION_POLICIES view.
-- Call Syntax  : @redaction_policies
-- Last Modified: 27-NOV-2014
-- -----------------------------------------------------------------------------------

SET LINESIZE 200

COLUMN object_owner FORMAT A20
COLUMN object_name FORMAT A30
COLUMN policy_name FORMAT A30
COLUMN expression FORMAT A30
COLUMN policy_description FORMAT A20

SELECT object_owner,
       object_name,
       policy_name,
       expression,
       enable,
       policy_description
FROM   redaction_policies
ORDER BY 1, 2, 3;