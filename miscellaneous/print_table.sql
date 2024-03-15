-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/miscellaneous/print_table.sql
-- Author       : Tom Kyte
-- Reference    : https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:1035431863958#14442395195806
-- Description  : Turns resultset columns into rows for any query.
-- Requirements : 
-- Call Syntax  : set server output on
--                exec print_table('select * from my_table');
-- Last Modified: 18-DEC-2003
-- -----------------------------------------------------------------------------------

create or replace
procedure print_table
( p_query in varchar2,
p_date_fmt in varchar2 default 'dd-mon-yyyy hh24:mi:ss' )

-- this utility is designed to be installed ONCE in a database and used
-- by all. Also, it is nice to have roles enabled so that queries by
-- DBA's that use a role to gain access to the DBA_* views still work
-- that is the purpose of AUTHID CURRENT_USER
AUTHID CURRENT_USER
is
l_theCursor integer default dbms_sql.open_cursor;
l_columnValue varchar2(4000);
l_status integer;
l_descTbl dbms_sql.desc_tab;
l_colCnt number;
l_cs varchar2(255);
l_date_fmt varchar2(255);

-- small inline procedure to restore the sessions state
-- we may have modified the cursor sharing and nls date format
-- session variables, this just restores them
procedure restore
is
begin
if ( upper(l_cs) not in ( 'FORCE','SIMILAR' ))
then
execute immediate
'alter session set cursor_sharing=exact';
end if;
if ( p_date_fmt is not null )
then
execute immediate
'alter session set nls_date_format=''' || l_date_fmt || '''';
end if;
dbms_sql.close_cursor(l_theCursor);
end restore;
begin
-- I like to see the dates print out with times, by default, the
-- format mask I use includes that. In order to be "friendly"
-- we save the date current sessions date format and then use
-- the one with the date and time. Passing in NULL will cause
-- this routine just to use the current date format
if ( p_date_fmt is not null )
then
select sys_context( 'userenv', 'nls_date_format' )
into l_date_fmt
from dual;

execute immediate
'alter session set nls_date_format=''' || p_date_fmt || '''';
end if;

-- to be bind variable friendly on this ad-hoc queries, we
-- look to see if cursor sharing is already set to FORCE or
-- similar, if not, set it so when we parse -- literals
-- are replaced with binds
if ( dbms_utility.get_parameter_value
( 'cursor_sharing', l_status, l_cs ) = 1 )
then
if ( upper(l_cs) not in ('FORCE','SIMILAR'))
then
execute immediate
'alter session set cursor_sharing=force';
end if;
end if;

-- parse and describe the query sent to us. we need
-- to know the number of columns and their names.
dbms_sql.parse( l_theCursor, p_query, dbms_sql.native );
dbms_sql.describe_columns
( l_theCursor, l_colCnt, l_descTbl );

-- define all columns to be cast to varchar2's, we
-- are just printing them out
for i in 1 .. l_colCnt loop
if ( l_descTbl(i).col_type not in ( 113 ) )
then
dbms_sql.define_column
(l_theCursor, i, l_columnValue, 4000);
end if;
end loop;

-- execute the query, so we can fetch
l_status := dbms_sql.execute(l_theCursor);

-- loop and print out each column on a separate line
-- bear in mind that dbms_output only prints 255 characters/line
-- so we'll only see the first 200 characters by my design...
while ( dbms_sql.fetch_rows(l_theCursor) > 0 )
loop
for i in 1 .. l_colCnt loop
if ( l_descTbl(i).col_type not in ( 113 ) )
then
dbms_sql.column_value
( l_theCursor, i, l_columnValue );
dbms_output.put_line
( rpad( l_descTbl(i).col_name, 30 )
|| ': ' ||
substr( l_columnValue, 1, 200 ) );
end if;
end loop;
dbms_output.put_line( '-----------------' );
end loop;

-- now, restore the session state, no matter what
restore;
exception
when others then
restore;
raise;
end;
/
