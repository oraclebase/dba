-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/miscellaneous/string_agg.sql
-- Author       : Tim Hall (based on an a method suggested by Tom Kyte).
--                http://asktom.oracle.com/pls/ask/f?p=4950:8:::::F4950_P8_DISPLAYID:229614022562
-- Description  : Aggregate function to concatenate strings.
-- Call Syntax  : Incorporate into queries as follows:
--                  COLUMN employees FORMAT A50
--                  
--                  SELECT deptno, string_agg(ename) AS employees
--                  FROM   emp
--                  GROUP BY deptno;
--                  
--                      DEPTNO EMPLOYEES
--                  ---------- --------------------------------------------------
--                          10 CLARK,KING,MILLER
--                          20 SMITH,FORD,ADAMS,SCOTT,JONES
--                          30 ALLEN,BLAKE,MARTIN,TURNER,JAMES,WARD
--                  
-- Last Modified: 03-JAN-2018 : Correction to separator handling in ODCIAggregateTerminate
--                              and ODCIAggregateMerge, suggested by Kim Berg Hansen.
-- -----------------------------------------------------------------------------------
CREATE OR REPLACE TYPE t_string_agg AS OBJECT
(
  g_string  VARCHAR2(32767),

  STATIC FUNCTION ODCIAggregateInitialize(sctx  IN OUT  t_string_agg)
    RETURN NUMBER,

  MEMBER FUNCTION ODCIAggregateIterate(self   IN OUT  t_string_agg,
                                       value  IN      VARCHAR2 )
     RETURN NUMBER,

  MEMBER FUNCTION ODCIAggregateTerminate(self         IN   t_string_agg,
                                         returnValue  OUT  VARCHAR2,
                                         flags        IN   NUMBER)
    RETURN NUMBER,

  MEMBER FUNCTION ODCIAggregateMerge(self  IN OUT  t_string_agg,
                                     ctx2  IN      t_string_agg)
    RETURN NUMBER
);
/
SHOW ERRORS


CREATE OR REPLACE TYPE BODY t_string_agg IS
  STATIC FUNCTION ODCIAggregateInitialize(sctx  IN OUT  t_string_agg)
    RETURN NUMBER IS
  BEGIN
    sctx := t_string_agg(NULL);
    RETURN ODCIConst.Success;
  END;

  MEMBER FUNCTION ODCIAggregateIterate(self   IN OUT  t_string_agg,
                                       value  IN      VARCHAR2 )
    RETURN NUMBER IS
  BEGIN
    SELF.g_string := self.g_string || ',' || value;
    RETURN ODCIConst.Success;
  END;

  MEMBER FUNCTION ODCIAggregateTerminate(self         IN   t_string_agg,
                                         returnValue  OUT  VARCHAR2,
                                         flags        IN   NUMBER)
    RETURN NUMBER IS
  BEGIN
    returnValue := SUBSTR(SELF.g_string, 2);
    RETURN ODCIConst.Success;
  END;

  MEMBER FUNCTION ODCIAggregateMerge(self  IN OUT  t_string_agg,
                                     ctx2  IN      t_string_agg)
    RETURN NUMBER IS
  BEGIN
    SELF.g_string := SELF.g_string || ctx2.g_string;
    RETURN ODCIConst.Success;
  END;
END;
/
SHOW ERRORS


CREATE OR REPLACE FUNCTION string_agg (p_input VARCHAR2)
RETURN VARCHAR2
PARALLEL_ENABLE AGGREGATE USING t_string_agg;
/
SHOW ERRORS
