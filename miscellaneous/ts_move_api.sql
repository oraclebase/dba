CREATE OR REPLACE PACKAGE ts_move_api AUTHID CURRENT_USER AS
-- --------------------------------------------------------------------------
-- Name         : https://oracle-base.com/dba/miscellaneous/ts_move_api.sql
-- Author       : Tim Hall
-- Description  : Allows you to move objects between tablespaces.
-- Requirements : The package should be run by a DBA user.
--
--                The following grants are needed for this package to compile.
--
--                GRANT SELECT ON dba_tables TO username;
--                GRANT SELECT ON dba_tab_partitions TO username;
--                GRANT SELECT ON dba_indexes TO username;
--                GRANT SELECT ON dba_ind_partitions TO username;
--                GRANT SELECT ON dba_lobs TO username;
--
-- License      : Free for personal and commercial use.
--                You can amend the code, but leave existing the headers, current
--                amendments history and links intact.
--                Copyright and disclaimer available here:
--                https://oracle-base.com/misc/site-info.php#copyright
-- Ammedments   :
--   When         Who       What
--   ===========  ========  =================================================
--   20-JUN-2010  Tim Hall  Initial Creation
-- --------------------------------------------------------------------------

PROCEDURE move_tables(
  p_from_ts  IN VARCHAR2,
  p_to_ts    IN VARCHAR2
);

PROCEDURE move_part_tables(
  p_from_ts  IN VARCHAR2,
  p_to_ts    IN VARCHAR2
);

PROCEDURE move_indexes(
  p_from_ts  IN VARCHAR2,
  p_to_ts    IN VARCHAR2
);

PROCEDURE move_part_indexes(
  p_from_ts  IN VARCHAR2,
  p_to_ts    IN VARCHAR2
);

PROCEDURE move_lobs(
  p_from_ts  IN VARCHAR2,
  p_to_ts    IN VARCHAR2
);

END ts_move_api;
/
SHOW ERRORS



CREATE OR REPLACE PACKAGE BODY ts_move_api AS
-- --------------------------------------------------------------------------
-- Name         : https://oracle-base.com/dba/miscellaneous/ts_move_api.sql
-- Author       : Tim Hall
-- Description  : Allows you to move objects between tablespaces.
-- Requirements : The package should be run by a DBA user.
--
--                The following grants are needed for this package to compile.
--
--                GRANT SELECT ON dba_tables TO username;
--                GRANT SELECT ON dba_tab_partitions TO username;
--                GRANT SELECT ON dba_indexes TO username;
--                GRANT SELECT ON dba_ind_partitions TO username;
--                GRANT SELECT ON dba_lobs TO username;
--
-- License      : Free for personal and commercial use.
--                You can amend the code, but leave existing the headers, current
--                amendments history and links intact.
--                Copyright and disclaimer available here:
--                https://oracle-base.com/misc/site-info.php#copyright
-- Ammedments   :
--   When         Who       What
--   ===========  ========  =================================================
--   20-JUN-2010  Tim Hall  Initial Creation
-- --------------------------------------------------------------------------

g_sql VARCHAR2(32767);

-- -----------------------------------------------------------------------------
PROCEDURE move_tables(
  p_from_ts  IN VARCHAR2,
  p_to_ts    IN VARCHAR2
) AS

BEGIN
  FOR cur_rec IN (SELECT owner, table_name
                  FROM   dba_tables
                  WHERE  tablespace_name = UPPER(p_from_ts)
                  AND    partitioned = 'NO'
                  AND    temporary = 'N')
  LOOP
    BEGIN
      g_sql := 'ALTER TABLE "' || cur_rec.owner || '"."' || cur_rec.table_name || '" MOVE TABLESPACE ' || p_to_ts;
      EXECUTE IMMEDIATE g_sql;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('ERROR: ' || g_sql);
        DBMS_OUTPUT.put_line('ERROR: ' || SQLERRM);
    END;
  END LOOP;
END move_tables;
-- -----------------------------------------------------------------------------


-- -----------------------------------------------------------------------------
PROCEDURE move_part_tables(
  p_from_ts  IN VARCHAR2,
  p_to_ts    IN VARCHAR2
) AS

BEGIN
  -- Table partitions.
  FOR cur_rec IN (SELECT table_owner, table_name, partition_name
                  FROM   dba_tab_partitions
                  WHERE  tablespace_name = UPPER(p_from_ts))
  LOOP
    BEGIN
      g_sql := 'ALTER TABLE "' || cur_rec.table_owner || '"."' || cur_rec.table_name || '" MOVE PARTITION "' || cur_rec.partition_name || '" TABLESPACE ' || p_to_ts;
      EXECUTE IMMEDIATE g_sql;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('ERROR: ' || g_sql);
        DBMS_OUTPUT.put_line('ERROR: ' || SQLERRM);
    END;
  END LOOP;

  -- Partitioned table defaults.
  FOR cur_rec IN (SELECT owner, table_name
                  FROM   dba_tables
                  WHERE  tablespace_name = UPPER(p_from_ts)
                  AND    partitioned = 'YES')
  LOOP
    BEGIN
      g_sql := 'ALTER TABLE "' || cur_rec.owner || '"."' || cur_rec.table_name || '" MODIFY DEFAULT ATTRIBUTES TABLESPACE ' || p_to_ts;
      EXECUTE IMMEDIATE g_sql;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('ERROR: ' || g_sql);
        DBMS_OUTPUT.put_line('ERROR: ' || SQLERRM);
    END;
  END LOOP;
END move_part_tables;
-- -----------------------------------------------------------------------------


-- -----------------------------------------------------------------------------
PROCEDURE move_indexes(
  p_from_ts  IN VARCHAR2,
  p_to_ts    IN VARCHAR2
) AS

BEGIN
  FOR cur_rec IN (SELECT owner, index_name
                  FROM   dba_indexes
                  WHERE  tablespace_name = UPPER(p_from_ts)
                  AND    partitioned = 'NO'
                  AND    index_type != 'LOB')
  LOOP
    BEGIN
      g_sql := 'ALTER INDEX "' || cur_rec.owner || '"."' || cur_rec.index_name || '" REBUILD TABLESPACE ' || p_to_ts;
      EXECUTE IMMEDIATE g_sql;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('ERROR: ' || g_sql);
        DBMS_OUTPUT.put_line('ERROR: ' || SQLERRM);
    END;
  END LOOP;
END move_indexes;
-- -----------------------------------------------------------------------------


-- -----------------------------------------------------------------------------
PROCEDURE move_part_indexes(
  p_from_ts  IN VARCHAR2,
  p_to_ts    IN VARCHAR2
) AS

BEGIN
  -- Index partitions.
  FOR cur_rec IN (SELECT index_owner, index_name, partition_name
                  FROM   dba_ind_partitions
                  WHERE  tablespace_name = UPPER(p_from_ts))
  LOOP
    BEGIN
      g_sql := 'ALTER INDEX "' || cur_rec.index_owner || '"."' || cur_rec.index_name || '" REBUILD PARTITION "' || cur_rec.partition_name || '" TABLESPACE ' || p_to_ts;
      EXECUTE IMMEDIATE g_sql;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('ERROR: ' || g_sql);
        DBMS_OUTPUT.put_line('ERROR: ' || SQLERRM);
    END;
  END LOOP;

  -- Partitioned index default.
  FOR cur_rec IN (SELECT owner, index_name
                  FROM   dba_indexes
                  WHERE  tablespace_name = UPPER(p_from_ts)
                  AND    partitioned = 'YES')
  LOOP
    BEGIN
      g_sql := 'ALTER INDEX "' || cur_rec.owner || '"."' || cur_rec.index_name || '" MODIFY DEFAULT ATTRIBUTES TABLESPACE ' || p_to_ts;
      EXECUTE IMMEDIATE g_sql;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('ERROR: ' || g_sql);
        DBMS_OUTPUT.put_line('ERROR: ' || SQLERRM);
    END;
  END LOOP;
END move_part_indexes;
-- -----------------------------------------------------------------------------


-- -----------------------------------------------------------------------------
PROCEDURE move_lobs(
  p_from_ts  IN VARCHAR2,
  p_to_ts    IN VARCHAR2
) AS

BEGIN
  FOR cur_rec IN (SELECT owner, table_name, column_name
                  FROM   dba_lobs
                  WHERE  tablespace_name = UPPER(p_from_ts)
                  AND    partitioned = 'NO')
  LOOP
    BEGIN
      g_sql := 'ALTER TABLE "' || cur_rec.owner || '"."' || cur_rec.table_name || '" MOVE LOB("' || cur_rec.column_name || '") STORE AS (TABLESPACE ' || p_to_ts || ')';
      EXECUTE IMMEDIATE g_sql;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('ERROR: ' || g_sql);
        DBMS_OUTPUT.put_line('ERROR: ' || SQLERRM);
    END;
  END LOOP;
END move_lobs;
-- -----------------------------------------------------------------------------

END ts_move_api;
/
SHOW ERRORS
