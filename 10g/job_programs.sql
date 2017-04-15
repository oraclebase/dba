-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/10g/job_programs.sql
-- Author       : Tim Hall
-- Description  : Displays scheduler information about job programs.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @job_programs
-- Last Modified: 27/07/2005
-- -----------------------------------------------------------------------------------
SET LINESIZE 250

COLUMN owner FORMAT A20
COLUMN program_name FORMAT A30
COLUMN program_action FORMAT A50
COLUMN comments FORMAT A40

SELECT owner,
       program_name,
       program_type,
       program_action,
       number_of_arguments,
       enabled,
       comments
FROM   dba_scheduler_programs
ORDER BY owner, program_name;
