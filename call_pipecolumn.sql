-- arg 1 table
-- arg 2 column
-- arg 3 new table
-- arg 4 command

SELECT a FROM ( -- inhibit the output of writefile
SELECT writefile('.sqlite_temp/docall2.out', group_concat(lines.block, char(10))) a -- group_concat to glue
FROM (
WITH THE_CALL AS (
    SELECT arg1 AS THE_TABLE, arg2 AS THE_COLUMN, arg3 AS THE_NEW_TABLE, arg4 AS DO_TRIM, arg5 AS THE_COMMAND
    FROM api._call
     )
SELECT 0 AS key, "CREATE TABLE IF NOT EXISTS `" || THE_NEW_TABLE || "` (src_rowid, line);" AS block
  FROM THE_CALL
UNION ALL
SELECT 0 AS key,
    "SELECT writefile('.sqlite_temp/docall3.out', GROUP_CONCAT(a, char(13) || char(10))) AS a FROM (" ||

    "SELECT '.shell echo ' || json_quote(`" || THE_COLUMN ||"`) || ' | " || replace(THE_COMMAND, "'", "''")
    ||  ' > .sqlite_temp/shell.out' || char(13) || char(10)
    || 'INSERT INTO `' || THE_NEW_TABLE || '` '
    || "VALUES ( ' || rowid || ', "
    || CASE
        WHEN DO_TRIM == "1" OR UPPER(DO_TRIM)=="T" THEN "RTRIM("
        ELSE ""
        END
    || "readfile(" || '"' || ".sqlite_temp/shell.out" || '"' || ")"
    || CASE
        WHEN DO_TRIM == "1" OR upper(DO_TRIM) == "T" THEN ", CHAR(10) || CHAR(13))"
        ELSE ""
        END
    || ");"
    || "'"
    || " AS a FROM `" || THE_TABLE || "`"
    || ")"
    || ";" || char(13) || char(10)
    AS block

FROM THE_call
UNION ALL
SELECT 0, '.read .sqlite_temp/docall3.out'
 ) lines
 GROUP BY key
 ) WHERE a = 0;

.read .sqlite_temp/docall2.out


-- create table foo (value);

-- INSERT INTO foo VALUES ('some thing'), ('other thing'), ('whatever');
-- .pipecolumn foo value food 1 sed 's/thing/xxx/'
-- insert into api.call (func, arg1, arg2, arg3, arg4) values ('pipecolumn', 'foo', 'value', 'food', 'sed "s/thing/xxxx/"');
-- .read sqlite_api/api.sql