-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/tables_with_zero_rows.sql
-- Author       : Tim Hall
-- Description  : Displays tables with stats saying they have zero rows.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @tables_with_zero_rows.sql
-- Last Modified: 06-DEC-2013
-- -----------------------------------------------------------------------------------

SELECT owner,
       table_name,
       last_analyzed,
       num_rows
FROM   dba_tables
WHERE  num_rows = 0
AND    owner NOT IN ('SYS','SYSTEM','SYSMAN','XDB','MDSYS',
                     'WMSYS','OUTLN','ORDDATA','ORDSYS',
                     'OLAPSYS','EXFSYS','DBNSMP','CTXSYS',
                     'APEX_030200','FLOWS_FILES','SCOTT',
                     'TSMSYS','DBSNMP','APPQOSSYS','OWBSYS',
                     'DMSYS','FLOWS_030100','WKSYS','WK_TEST')
ORDER BY owner, table_name;
