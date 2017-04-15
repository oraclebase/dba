-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/12c/host_acls.sql
-- Author       : Tim Hall
-- Description  : Displays information about host ACLs.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @host_acls
-- Last Modified: 10/09/2014
-- -----------------------------------------------------------------------------------
SET LINESIZE 150

COLUMN acl FORMAT A50
COLUMN host FORMAT A20
COLUMN acl_owner FORMAT A10

SELECT HOST,
       LOWER_PORT,
       UPPER_PORT,
       ACL,
       ACLID,
       ACL_OWNER
FROM   dba_host_acls
ORDER BY host;

SET LINESIZE 80