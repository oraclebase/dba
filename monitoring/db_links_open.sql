-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/db_links_open.sql
-- Author       : Tim Hall
-- Description  : Displays information on all open database links.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @db_links_open
-- Last Modified: 11/05/2007
-- -----------------------------------------------------------------------------------
SET LINESIZE 200

COLUMN db_link FORMAT A30

SELECT db_link,
       owner_id,
       logged_on,
       heterogeneous,
       protocol,
       open_cursors,
       in_transaction,
       update_sent,
       commit_point_strength
FROM   v$dblink
ORDER BY db_link;

SET LINESIZE 80
