-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/script_creation/backup.sql
-- Author       : Tim Hall
-- Description  : Creates a very basic hot-backup script. A useful starting point.
-- Call Syntax  : @backup
-- Last Modified: 28/01/2001
-- -----------------------------------------------------------------------------------
SET SERVEROUTPUT ON
SET LINESIZE 1000
SET TRIMOUT ON
SET FEEDBACK OFF
SPOOL Backup.txt

DECLARE

    CURSOR c_tablespace IS
        SELECT a.tablespace_name
        FROM   dba_tablespaces a
        ORDER BY 1;

    CURSOR c_datafiles (in_ts_name  IN  VARCHAR2) IS
        SELECT a.file_name
        FROM   dba_data_files a
        WHERE  a.tablespace_name = in_ts_name
        ORDER BY 1;

    CURSOR c_archive_redo IS
        SELECT a.value 
        FROM   v$parameter a
        WHERE  a.name = \'log_archive_dest\';

    v_sid            VARCHAR2(100) := \'ORCL\';
    v_backup_com     VARCHAR2(100) := \'!ocopy \';
    v_remove_com     VARCHAR2(100) := \'!rm\';
    v_dest_loc       VARCHAR2(100) := \'/opt/oracleddds/dbs1/oradata/ddds/\';

BEGIN

    DBMS_Output.Disable;
    DBMS_Output.Enable(1000000);

    DBMS_Output.Put_Line(\'svrmgrl\');
    DBMS_Output.Put_Line(\'connect internal\');

    DBMS_Output.Put_Line(\'	\');
    DBMS_Output.Put_Line(\'-- ----------------------\');
    DBMS_Output.Put_Line(\'-- Backup all tablespaces\');
    DBMS_Output.Put_Line(\'-- ----------------------\');
    FOR cur_ts IN c_tablespace LOOP
        DBMS_Output.Put_Line(\'	\');
        DBMS_Output.Put_Line(\'ALTER TABLESPACE \' || cur_ts.tablespace_name || \' BEGIN BACKUP;\');
        FOR cur_df IN c_datafiles (in_ts_name => cur_ts.tablespace_name) LOOP
            DBMS_Output.Put_Line(v_backup_com || \' \' || cur_df.file_name || \' \' || 
                                 v_dest_loc || SUBSTR(cur_df.file_name, INSTR(cur_df.file_name, \'/\', -1)+1));
        END LOOP;
        DBMS_Output.Put_Line(\'ALTER TABLESPACE \' || cur_ts.tablespace_name || \' END BACKUP;\');
    END LOOP;

    DBMS_Output.Put_Line(\'	\');
    DBMS_Output.Put_Line(\'-- -----------------------------\');
    DBMS_Output.Put_Line(\'-- Backup the archived redo logs\');
    DBMS_Output.Put_Line(\'-- -----------------------------\');
    FOR cur_ar IN c_archive_redo LOOP
        DBMS_Output.Put_Line(v_backup_com || \' \' || cur_ar.value || \'/* \' ||
                             v_dest_loc);
    END LOOP;


    DBMS_Output.Put_Line(\'	\');
    DBMS_Output.Put_Line(\'-- ----------------------\');
    DBMS_Output.Put_Line(\'-- Backup the controlfile\');
    DBMS_Output.Put_Line(\'-- ----------------------\');
    DBMS_Output.Put_Line(\'ALTER DATABASE BACKUP CONTROLFILE TO \'\'\' || v_dest_loc || v_sid || \'Controlfile.backup\'\';\');
    DBMS_Output.Put_Line(v_backup_com || \' \' || v_dest_loc || v_sid || \'Controlfile.backup\');
    DBMS_Output.Put_Line(v_remove_com || \' \' || v_dest_loc || v_sid || \'Controlfile.backup\');

    DBMS_Output.Put_Line(\'	\');
    DBMS_Output.Put_Line(\'EXIT\');

END;
/

PROMPT
SPOOL OFF
SET LINESIZE 80
SET FEEDBACK ON