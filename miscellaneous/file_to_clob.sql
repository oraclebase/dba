CREATE OR REPLACE PROCEDURE file_to_clob (p_clob      IN OUT NOCOPY CLOB,
                                          p_dir       IN  VARCHAR2,
                                          p_filename  IN  VARCHAR2)
-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/miscellaneous/file_to_clob.sql
-- Author       : Tim Hall
-- Description  : Loads the contents of a file into a CLOB.
-- Last Modified: 26/02/2019 - Taken from 2005 article.
-- -----------------------------------------------------------------------------------
AS
  l_bfile  BFILE;

  l_dest_offset   INTEGER := 1;
  l_src_offset    INTEGER := 1;
  l_bfile_csid    NUMBER  := 0;
  l_lang_context  INTEGER := 0;
  l_warning       INTEGER := 0;
BEGIN
  l_bfile := BFILENAME(p_dir, p_filename);
  DBMS_LOB.fileopen(l_bfile, DBMS_LOB.file_readonly);
  DBMS_LOB.trim(p_clob, 0);
  DBMS_LOB.loadclobfromfile (
    dest_lob      => p_clob,
    src_bfile     => l_bfile,
    amount        => DBMS_LOB.lobmaxsize,
    dest_offset   => l_dest_offset,
    src_offset    => l_src_offset,
    bfile_csid    => l_bfile_csid ,
    lang_context  => l_lang_context,
    warning       => l_warning);
  DBMS_LOB.fileclose(l_bfile);
END file_to_clob;
/
