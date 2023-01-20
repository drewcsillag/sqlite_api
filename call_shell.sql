-- arg1 THE_TABLE
-- arg2 THE_COMMAND

SELECT a FROM ( -- inhibit the output of writefile
SELECT writefile('.sqlite_temp/docall2.out', group_concat(lines.block, char(10))) a -- group_concat to glue
FROM (
WITH THE_CALL AS (
   SELECT arg1 AS THE_TABLE, arg2 AS THE_COMMAND FROM api._call)
SELECT
    0 AS KEY, ".shell " || THE_COMMAND || " > .sqlite_temp/shell.out" AS block
    FROM THE_CALL
UNION ALL
--- from here down is mostly copy/paste from call_loadlines.sql
SELECT
    0 AS KEY, "CREATE TABLE IF NOT EXISTS `" || THE_TABLE || "` (line);" AS block
  FROM THE_CALL
UNION ALL
SELECT
    0, "WITH split(word, str) AS (
    SELECT 'C78C8DAC-5DF3-4D5D-BB96-C5A6AB04EB7F', readfile('.sqlite_temp/shell.out') || CHAR(10)
    UNION ALL
    SELECT
        substr(str, 0, instr(str, CHAR(10))),
        substr(str, instr(str, CHAR(10))+1)
    FROM split
    WHERE str!=''
) INSERT INTO `" || THE_TABLE || "` SELECT word FROM split
  WHERE word != 'C78C8DAC-5DF3-4D5D-BB96-C5A6AB04EB7F';"
 FROM THE_call
 ) lines
 GROUP BY key
 ) WHERE a = 0;

.read .sqlite_temp/docall2.out
