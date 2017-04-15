-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/ts_extent_map.sql
-- Author       : Tim Hall
-- Description  : Displays gaps (empty space) in a tablespace or specific datafile.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @ts_extent_map (tablespace-name) [all | file_id]
-- Last Modified: 25/01/2003
-- -----------------------------------------------------------------------------------
SET SERVEROUTPUT ON SIZE 1000000
SET FEEDBACK OFF
SET TRIMOUT ON
SET VERIFY OFF

DECLARE
  l_tablespace_name VARCHAR2(30) := UPPER('&1');
  l_file_id         VARCHAR2(30) := UPPER('&2');

  CURSOR c_extents IS
    SELECT owner,
           segment_name,
           file_id,
           block_id AS start_block,
           block_id + blocks - 1 AS end_block
    FROM   dba_extents
    WHERE  tablespace_name = l_tablespace_name
    AND    file_id = DECODE(l_file_id, 'ALL', file_id, TO_NUMBER(l_file_id))
    ORDER BY file_id, block_id;

  l_block_size     NUMBER  := 0;
  l_last_file_id   NUMBER  := 0;
  l_last_block_id  NUMBER  := 0;
  l_gaps_only      BOOLEAN := TRUE;
  l_total_blocks   NUMBER  := 0;
BEGIN
  SELECT block_size
  INTO   l_block_size
  FROM   dba_tablespaces
  WHERE  tablespace_name = l_tablespace_name;

  DBMS_OUTPUT.PUT_LINE('Tablespace Block Size (bytes): ' || l_block_size);
  FOR cur_rec IN c_extents LOOP
    IF cur_rec.file_id != l_last_file_id THEN
      l_last_file_id  := cur_rec.file_id;
      l_last_block_id := cur_rec.start_block - 1;
    END IF;
    
    IF cur_rec.start_block > l_last_block_id + 1 THEN
      DBMS_OUTPUT.PUT_LINE('*** GAP *** (' || l_last_block_id || ' -> ' || cur_rec.start_block || ')' ||
        ' FileID=' || cur_rec.file_id ||
        ' Blocks=' || (cur_rec.start_block-l_last_block_id-1) || 
        ' Size(MB)=' || ROUND(((cur_rec.start_block-l_last_block_id-1) * l_block_size)/1024/1024,2)
      );
      l_total_blocks := l_total_blocks + cur_rec.start_block - l_last_block_id-1;
    END IF;
    l_last_block_id := cur_rec.end_block;
    IF NOT l_gaps_only THEN
      DBMS_OUTPUT.PUT_LINE(RPAD(cur_rec.owner || '.' || cur_rec.segment_name, 40, ' ') ||
                           ' (' || cur_rec.start_block || ' -> ' || cur_rec.end_block || ')');
    END IF;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('Total Gap Blocks: ' || l_total_blocks);
  DBMS_OUTPUT.PUT_LINE('Total Gap Space (MB): ' || ROUND((l_total_blocks * l_block_size)/1024/1024,2));
END;
/

PROMPT
SET FEEDBACK ON
