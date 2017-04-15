-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/12c/login.sql
-- Author       : Tim Hall
-- Description  : Resets the SQL*Plus prompt when a new connection is made.
--                Includes PDB:CDB.
-- Call Syntax  : @login
-- Last Modified: 21/04/2014
-- -----------------------------------------------------------------------------------
SET FEEDBACK OFF
SET TERMOUT OFF

COLUMN X NEW_VALUE Y
SELECT LOWER(USER || '@' || 
             SYS_CONTEXT('userenv', 'con_name') || ':' || 
             SYS_CONTEXT('userenv', 'instance_name')) X
FROM dual;
SET SQLPROMPT '&Y> '

ALTER SESSION SET NLS_DATE_FORMAT='DD-MON-YYYY HH24:MI:SS'; 
ALTER SESSION SET NLS_TIMESTAMP_FORMAT='DD-MON-YYYY HH24:MI:SS.FF'; 

SET TERMOUT ON
SET FEEDBACK ON
SET LINESIZE 100
SET TAB OFF
SET TRIM ON
SET TRIMSPOOL ON