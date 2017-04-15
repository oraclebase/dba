-- -----------------------------------------------------------------------------------
-- File Name    : http://www.oracle-base.com/dba/monitoring/hidden_parameters.sql
-- Author       : DR Timothy S Hall
-- Description  : Displays a list of one or all the hidden parameters.
-- Requirements : Access to the v$ views.
-- Call Syntax  : @hidden_parameters (parameter-name or all)
-- Last Modified: 28-NOV-2006
-- -----------------------------------------------------------------------------------
SET VERIFY OFF
COLUMN parameter      FORMAT a37
COLUMN description    FORMAT a30 WORD_WRAPPED
COLUMN session_value  FORMAT a10
COLUMN instance_value FORMAT a10
 
SELECT a.ksppinm AS parameter,
       a.ksppdesc AS description,
       b.ksppstvl AS session_value,
       c.ksppstvl AS instance_value
FROM   x$ksppi a,
       x$ksppcv b,
       x$ksppsv c
WHERE  a.indx = b.indx
AND    a.indx = c.indx
AND    a.ksppinm LIKE '/_%' ESCAPE '/'
AND    a.ksppinm = DECODE(LOWER('&1'), 'all', a.ksppinm, LOWER('&1'))
ORDER BY a.ksppinm;
