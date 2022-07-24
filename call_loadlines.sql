-- arg 1 THE_FILENAME
-- arg 2 THE_TABLE

-- generate a create table (if not exist) and a sqlstatement that looks like this

-- .once docall2.out
-- CREATE TABLE IF NOT EXISTS THE_TABLE (name, line)

-- WITH split(word, str) AS (
--     SELECT '', readfile('THE_FILENAME') || CHAR(10)
--     UNION ALL SELECT
--     substr(str, 0, instr(str, CHAR(10))),
--     substr(str, instr(str, CHAR(10))+1)
--     FROM split WHERE str!=''
-- ) insert into x SELECT THE_FILENAME,  word FROM split WHERE word!='';
-- .read docall2.out

-- the UUID below is just for a unique sentinel value -- so on the really random chance
-- that you have a line that's just that uuid, it'll be omitted.

SELECT a FROM ( -- to inhibit the output of writefile
SELECT writefile('.sqlite_temp/docall2.out', group_concat(lines.block, char(10))) a -- group_concat to glue
FROM (
WITH THE_CALL AS (
   SELECT arg1 AS THE_FILENAME, arg2 AS THE_TABLE FROM api._call
   )
SELECT 0 AS key, "CREATE TABLE IF NOT EXISTS `" || THE_TABLE || "` (name, line);" AS block
  FROM THE_CALL
UNION ALL
SELECT 0, "WITH split(word, str) AS (
    SELECT 'C78C8DAC-5DF3-4D5D-BB96-C5A6AB04EB7F', readfile('" || THE_FILENAME || "') || CHAR(10)
    UNION ALL
    SELECT
        substr(str, 0, instr(str, CHAR(10))),
        substr(str, instr(str, CHAR(10))+1)
    FROM split
    WHERE str!=''
) INSERT INTO `" || THE_TABLE || "` SELECT """ || THE_FILENAME || """, word FROM split
  WHERE word != 'C78C8DAC-5DF3-4D5D-BB96-C5A6AB04EB7F';"
 FROM THE_call
 ) lines
 GROUP BY key
 ) WHERE a = 0;

.read .sqlite_temp/docall2.out
