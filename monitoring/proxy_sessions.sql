-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/proxy_sessions.sql
-- Author       : Tim Hall
-- Description  : Displays information on all database proxy sessions.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @proxy_sessions
-- Last Modified: 01-JUN-2021
-- -----------------------------------------------------------------------------------
set linesize 500
set pagesize 1000

column username format a30
column osuser format a20
column spid format a10
column service_name format a15
column module format a45
column machine format a30
column logon_time format a20

select nvl(s.username, '(oracle)') as username,
       s.osuser,
       s.sid,
       s.serial#,
       p.spid,
       s.lockwait,
       s.status,
       s.service_name,
       s.machine,
       s.program,
       to_char(s.logon_time,'dd-mon-yyyy hh24:mi:ss') as logon_time,
       s.last_call_et as last_call_et_secs,
       s.module,
       s.action,
       s.client_info,
       s.client_identifier
from   v$session s,
       v$process p,
       v$session_connect_info sci
where  s.paddr = p.addr
and    s.sid = sci.sid
and    s.serial# = sci.serial#
and    sci.authentication_type = 'PROXY'
order by s.username, s.osuser;

set pagesize 14
