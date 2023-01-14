-- arg1 THE_TABLE
-- arg2 THE_COLUMN
-- arg3 THE_NEW_TABLE
-- arg4 THE_DELIMITER_EXPR

SELECT a FROM ( -- inhibit the output of writefile
SELECT writefile('.sqlite_temp/docall2.out', group_concat(lines.block, char(10))) a -- group_concat to glue
FROM (
WITH THE_CALL AS (
   SELECT arg1 AS THE_TABLE, arg2 AS THE_COLUMN, arg3 AS THE_NEW_TABLE,
          arg4 AS THE_DELIMITER_EXPR FROM api._call)
SELECT 
    0 as KEY, "CREATE TABLE `" || THE_NEW_TABLE || "` (src_rowid, group_no, line);" AS block
    FROM THE_CALL

UNION ALL
    SELECT 0,
    "INSERT INTO `" || THE_NEW_TABLE || "`
    WITH delimiting AS (SELECT rowid, `" || THE_COLUMN || "` AS maybe_delimiter FROM `" || THE_TABLE || "`)
    SELECT 
        t1.rowid AS src_rowid,
        max(t2.rowid) AS group_no,
        t1.`" || THE_COLUMN || "`
    FROM `" || THE_TABLE || "` t1
    JOIN delimiting t2 ON t2.rowid <= t1.rowid
    WHERE " || THE_DELIMITER_EXPR || "
        OR t2.rowid = 1
    GROUP BY t1.rowid;"
FROM THE_CALL
) lines
 GROUP BY key
 ) WHERE a = 0;
;
.read .sqlite_temp/docall2.out

