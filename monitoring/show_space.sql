-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/show_space.sql
-- Author       : Tom Kyte
-- Description  : Displays free and unused space for the specified object.
-- Call Syntax  : EXEC Show_Space('Tablename');
-- Requirements : SET SERVEROUTPUT ON              
-- Last Modified: 10/09/2002
-- -----------------------------------------------------------------------------------
CREATE OR REPLACE
PROCEDURE show_space
( p_segname IN VARCHAR2,
  p_owner   IN VARCHAR2 DEFAULT user,
  p_type    IN VARCHAR2 DEFAULT 'TABLE' )
AS
  l_free_blks                 NUMBER;
  l_total_blocks              NUMBER;
  l_total_bytes               NUMBER;
  l_unused_blocks             NUMBER;
  l_unused_bytes              NUMBER;
  l_last_used_ext_file_id     NUMBER;
  l_last_used_ext_block_id        NUMBER;
  l_last_used_block           NUMBER;
  
  PROCEDURE p( p_label IN VARCHAR2, p_num IN NUMBER )
  IS
  BEGIN
     DBMS_OUTPUT.PUT_LINE( RPAD(p_label,40,'.') || p_num );
  END;
  
BEGIN
  DBMS_SPACE.FREE_BLOCKS (
    segment_owner     => p_owner,
    segment_name      => p_segname,
    segment_type      => p_type,
    freelist_group_id => 0,
    free_blks         => l_free_blks );

  DBMS_SPACE.UNUSED_SPACE ( 
    segment_owner             => p_owner,
    segment_name              => p_segname,
    segment_type              => p_type,
    total_blocks              => l_total_blocks,
    total_bytes               => l_total_bytes,
    unused_blocks             => l_unused_blocks,
    unused_bytes              => l_unused_bytes,
    last_used_extent_file_id  => l_last_used_ext_file_id,
    last_used_extent_block_id => l_last_used_ext_block_id,
    last_used_block           => l_last_used_block );
 
  p( 'Free Blocks', l_free_blks );
  p( 'Total Blocks', l_total_blocks );
  p( 'Total Bytes', l_total_bytes );
  p( 'Unused Blocks', l_unused_blocks );
  p( 'Unused Bytes', l_unused_bytes );
  p( 'Last Used Ext FileId', l_last_used_ext_file_id );
  p( 'Last Used Ext BlockId', l_last_used_ext_block_id );
  p( 'Last Used Block', l_LAST_USED_BLOCK );
END;
/