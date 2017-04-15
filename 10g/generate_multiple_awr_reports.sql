-- -----------------------------------------------------------------------------------
-- File Name    : http://www.oracle-base.com/dba/10g/generate_multiple_awr_reports.sql
-- Author       : DR Timothy S Hall
-- Description  : Generates AWR reports for all snapsots between the specified start and end point.
-- Requirements : Access to the v$ views, UTL_FILE and DBMS_WORKLOAD_REPOSITORY packages.
-- Call Syntax  : Create the directory with the appropriate path.
--                Adjust the start and end snapshots as required.
--                @generate_multiple_awr_reports.sql
-- Last Modified: 02/08/2007
-- -----------------------------------------------------------------------------------
CREATE OR REPLACE DIRECTORY awr_reports_dir AS '/tmp/';

DECLARE
  -- Adjust before use.
  l_snap_start       NUMBER := 1;
  l_snap_end         NUMBER := 10;
  l_dir              VARCHAR2(50) := 'AWR_REPORTS_DIR';
  
  l_last_snap        NUMBER := NULL;
  l_dbid             v$database.dbid%TYPE;
  l_instance_number  v$instance.instance_number%TYPE;
  l_file             UTL_FILE.file_type;
  l_file_name        VARCHAR(50);

BEGIN
  SELECT dbid
  INTO   l_dbid
  FROM   v$database;

  SELECT instance_number
  INTO   l_instance_number
  FROM   v$instance;
    
  FOR cur_snap IN (SELECT snap_id
                   FROM   dba_hist_snapshot
                   WHERE  instance_number = l_instance_number
                   AND    snap_id BETWEEN l_snap_start AND l_snap_end
                   ORDER BY snap_id)
  LOOP
    IF l_last_snap IS NOT NULL THEN
      l_file := UTL_FILE.fopen(l_dir, 'awr_' || l_last_snap || '_' || cur_snap.snap_id || '.htm', 'w', 32767);
      
      FOR cur_rep IN (SELECT output
                      FROM   TABLE(DBMS_WORKLOAD_REPOSITORY.awr_report_html(l_dbid, l_instance_number, l_last_snap, cur_snap.snap_id)))
      LOOP
        UTL_FILE.put_line(l_file, cur_rep.output);
      END LOOP;
      UTL_FILE.fclose(l_file);
    END IF;
    l_last_snap := cur_snap.snap_id;
  END LOOP;
  
EXCEPTION
  WHEN OTHERS THEN
    IF UTL_FILE.is_open(l_file) THEN
      UTL_FILE.fclose(l_file);
    END IF;
    RAISE; 
END;
/
