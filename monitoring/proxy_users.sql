-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/proxy_users.sql
-- Author       : Tim Hall
-- Description  : Displays information about proxy users.
-- Requirements : Access to the PROXY_USERS views.
-- Call Syntax  : @proxy_users.sql {username or %}
-- Last Modified: 02/06/2020
-- -----------------------------------------------------------------------------------

SET VERIFY OFF

COLUMN proxy FORMAT A30
COLUMN client FORMAT A30

SELECT proxy,
       client,
       authentication,
       flags
FROM   proxy_users
WHERE  proxy LIKE UPPER('%&1%');
