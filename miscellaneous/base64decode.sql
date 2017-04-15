CREATE OR REPLACE FUNCTION base64decode(p_clob CLOB)
  RETURN BLOB
-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/miscellaneous/base64decode.sql
-- Author       : Tim Hall
-- Description  : Decodes a Base64 CLOB into a BLOB
-- Last Modified: 09/11/2011
-- -----------------------------------------------------------------------------------
IS
  l_blob    BLOB;
  l_raw     RAW(32767);
  l_amt     NUMBER := 7700;
  l_offset  NUMBER := 1;
  l_temp    VARCHAR2(32767);
BEGIN
  BEGIN
    DBMS_LOB.createtemporary (l_blob, FALSE, DBMS_LOB.CALL);
    LOOP
      DBMS_LOB.read(p_clob, l_amt, l_offset, l_temp);
      l_offset := l_offset + l_amt;
      l_raw    := UTL_ENCODE.base64_decode(UTL_RAW.cast_to_raw(l_temp));
      DBMS_LOB.append (l_blob, TO_BLOB(l_raw));
    END LOOP;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
  END;
  RETURN l_blob;
END;
/