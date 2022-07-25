


SELECT a FROM ( -- to inhibit the output of writefile
SELECT writefile('.sqlite_temp/docall2.out', group_concat(lines.block, char(10))) a -- group_concat to glue
FROM (
WITH THE_CALL AS (
   SELECT arg1 AS THE_FILENAME, arg2 AS THE_TABLE FROM api._call
   )
SELECT 0 AS key, "CREATE TABLE IF NOT EXISTS `" || THE_TABLE || "` (name, prefix, line);" AS block
  FROM THE_CALL
UNION ALL
SELECT 0, 
"INSERT INTO `" || THE_TABLE || "` SELECT 
    '" || THE_FILENAME || "' AS name,
    CASE 
        WHEN instr(word, ':') > 0
        THEN substr(word, 1, instr(word, ':') - 1)
        ELSE ''
    END as prefix,
    CASE
        WHEN instr(word, ':') > 0
        THEN substr(word, instr(word, ':') + 1)
        ELSE word
    END as line 
FROM
(WITH split(word, str) AS (
    SELECT 'C78C8DAC-5DF3-4D5D-BB96-C5A6AB04EB7F', readfile('" || THE_FILENAME || "') || CHAR(10)
    UNION ALL
    SELECT
        substr(str, 0, instr(str, CHAR(10))),
        substr(str, instr(str, CHAR(10))+1)
    FROM split
    WHERE str!=''
) SELECT word FROM split 
  WHERE word != 'C78C8DAC-5DF3-4D5D-BB96-C5A6AB04EB7F')  
  ;"
 FROM THE_call
 ) lines
 GROUP BY key
 ) WHERE a = 0;
.read .sqlite_temp/docall2.out
