CREATE OR REPLACE PROCEDURE file_to_blob (p_blob      IN OUT NOCOPY BLOB,
                                          p_dir       IN  VARCHAR2,
                                          p_filename  IN  VARCHAR2)
-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/miscellaneous/file_to_blob.sql
-- Author       : Tim Hall
-- Description  : Loads the contents of a file into a BLOB.
-- Last Modified: 26/02/2019 - Taken from 2005 article.
-- -----------------------------------------------------------------------------------
AS
  l_bfile  BFILE;

  l_dest_offset INTEGER := 1;
  l_src_offset  INTEGER := 1;
BEGIN
  l_bfile := BFILENAME(p_dir, p_filename);
  DBMS_LOB.fileopen(l_bfile, DBMS_LOB.file_readonly);
  DBMS_LOB.trim(p_blob, 0);
  IF DBMS_LOB.getlength(l_bfile) > 0 THEN
    DBMS_LOB.loadblobfromfile (
      dest_lob    => p_blob,
      src_bfile   => l_bfile,
      amount      => DBMS_LOB.lobmaxsize,
      dest_offset => l_dest_offset,
      src_offset  => l_src_offset);
  END IF;
  DBMS_LOB.fileclose(l_bfile);
END file_to_blob;
/
