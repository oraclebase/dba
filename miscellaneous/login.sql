-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/miscellaneous/login.sql
-- Author       : Tim Hall
-- Description  : Resets the SQL*Plus prompt when a new connection is made.
-- Call Syntax  : @login
-- Last Modified: 04/03/2004
-- -----------------------------------------------------------------------------------
SET FEEDBACK OFF
SET TERMOUT OFF

COLUMN X NEW_VALUE Y
SELECT LOWER(USER || '@' || SYS_CONTEXT('userenv', 'instance_name')) X FROM dual;
SET SQLPROMPT '&Y> '

ALTER SESSION SET NLS_DATE_FORMAT='DD-MON-YYYY HH24:MI:SS'; 
ALTER SESSION SET NLS_TIMESTAMP_FORMAT='DD-MON-YYYY HH24:MI:SS.FF'; 

SET TERMOUT ON
SET FEEDBACK ON
SET LINESIZE 100
SET TAB OFF
SET TRIM ON
SET TRIMSPOOL ON
