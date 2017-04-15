-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/errors.sql
-- Author       : Tim Hall
-- Description  : Displays the source line and the associated error after compilation failure.
-- Comments     : Essentially the same as SHOW ERRORS.
-- Call Syntax  : @errors (source-name)
-- Last Modified: 15/07/2000
-- -----------------------------------------------------------------------------------
SELECT To_Char(a.line) || ' - ' || a.text error
FROM   user_source a,
       user_errors b
WHERE  a.name = Upper('&&1')
AND    a.name = b.name
AND    a.type = b.type
AND    a.line = b.line
ORDER BY a.name, a.line;