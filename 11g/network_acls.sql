-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/11g/network_acls.sql
-- Author       : Tim Hall
-- Description  : Displays information about network ACLs.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @network_acls
-- Last Modified: 30/11/2011
-- -----------------------------------------------------------------------------------
SET LINESIZE 150

COLUMN host FORMAT A40
COLUMN acl FORMAT A50

SELECT host, lower_port, upper_port, acl
FROM   dba_network_acls
ORDER BY host;

SET LINESIZE 80