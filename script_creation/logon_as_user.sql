-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/script_creation/logon_as_user.sql
-- Author       : Tim Hall
-- Description  : Displays the DDL for a specific user.
--                Better approaches included here.
--                https://oracle-base.com/articles/misc/proxy-users-and-connect-through
-- Call Syntax  : @logon_as_user (username)
-- Last Modified: 28/01/2006 - Added link to article.
-- -----------------------------------------------------------------------------------

set serveroutput on verify off
declare
  l_username VARCHAR2(30) :=  upper('&1');
  l_orig_pwd VARCHAR2(32767);
begin 
  select password
  into   l_orig_pwd
  from   sys.user$
  where  name = l_username;

  dbms_output.put_line('--');
  dbms_output.put_line('alter user ' || l_username || ' identified by DummyPassword1;');
  dbms_output.put_line('conn ' || l_username || '/DummyPassword1');

  dbms_output.put_line('--');
  dbms_output.put_line('-- Do something here.');
  dbms_output.put_line('--');

  dbms_output.put_line('conn / as sysdba');
  dbms_output.put_line('alter user ' || l_username || ' identified by values '''||l_orig_pwd||''';');
end;
/
