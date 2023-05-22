-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/11g/network_acl_privileges_by_host.sql
-- Author       : Tim Hall
-- Description  : Displays privileges for the network ACLs.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @network_acl_privileges_by_host (host | all)
-- Last Modified: 22/05/2023
-- -----------------------------------------------------------------------------------
SET LINESIZE 150

COLUMN acl FORMAT A50
COLUMN principal FORMAT A20
COLUMN privilege FORMAT A10

SELECT nap.acl,
       host,
       lower_port,
       upper_port,
       nap.principal,
       nap.privilege,
       nap.is_grant,
       TO_CHAR(nap.start_date, 'DD-MON-YYYY') AS start_date,
       TO_CHAR(nap.end_date, 'DD-MON-YYYY') AS end_date
FROM   dba_network_acl_privileges nap
       JOIN dba_network_acls na on na.acl = nap.acl
WHERE  host LIKE DECODE(UPPER('&1'), 'ALL', host, '%&1%')
ORDER BY nap.acl, nap.principal, nap.privilege;

SET LINESIZE 80
