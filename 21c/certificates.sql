-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/21c/certificates.sql
-- Author       : Tim Hall
-- Description  : Display certificates in the specified schema, or all schemas.
-- Call Syntax  : @certificates (schema or all)
-- Last Modified: 23/12/2020
-- -----------------------------------------------------------------------------------
set linesize 200 verify off trimspool on

column user_name format a10
column distinguished_name format a30
column certificate format a30

select user_name,
       certificate_guid,
       distinguished_name,
       substr(certificate, 1, 25) || '...' as certificate
from   dba_certificates
where  user_name = DECODE(UPPER('&1'), 'ALL', user_name, UPPER('&1'))
order by user_name;
