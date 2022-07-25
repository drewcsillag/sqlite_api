--call_split_on_colon.sql

SELECT a FROM ( -- to inhibit the output of writefile
SELECT writefile('.sqlite_temp/docall2.out', group_concat(lines.block, char(10))) a -- group_concat to glue
FROM (
WITH THE_CALL AS (
   SELECT arg1 AS THE_TABLE, arg2 AS THE_RETAIN_COLUMNS, arg3 AS THE_SPLIT_COLUMN, 
          arg4 AS THE_NEW_TABLE, arg5 AS THE_NEW_COLUMN FROM api._call
   )

SELECT 
   0 AS key, "CREATE TABLE `" || THE_NEW_TABLE || "` (src_rowid, " || THE_RETAIN_COLUMNS || ", " || THE_NEW_COLUMN || ", line);" AS block
   FROM THE_CALL
UNION ALL
   SELECT 0,
   "INSERT INTO `" || THE_NEW_TABLE || "`
   SELECT rowid, " || THE_RETAIN_COLUMNS || ", 
       substr(`" || THE_SPLIT_COLUMN || "`, 1, instr(`" || THE_SPLIT_COLUMN || "`, ':')-1),
       substr(`" || THE_SPLIT_COLUMN || "`, instr(`" || THE_SPLIT_COLUMN || "`, ':')+1) 
       FROM `" || THE_TABLE || "`;"


FROM THE_call
 ) lines
 GROUP BY key
 ) WHERE a = 0;
;
.read .sqlite_temp/docall2.out
