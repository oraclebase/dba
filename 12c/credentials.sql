-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/12c/credentials.sql
-- Author       : Tim Hall
-- Description  : Displays information about credentials.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @credentials
-- Last Modified: 18/12/2013
-- -----------------------------------------------------------------------------------
COLUMN credential_name FORMAT A25
COLUMN username FORMAT A20
COLUMN windows_domain FORMAT A20

SELECT credential_name,
       username,
       windows_domain
FROM   dba_credentials
ORDER BY credential_name;