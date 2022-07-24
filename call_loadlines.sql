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
-- .once docall2.out

.once .sqlite_temp/docall2.out
WITH THE_CALL AS (
   SELECT arg1 AS THE_FILENAME, arg2 AS THE_TABLE FROM api._call
   )
SELECT "CREATE TABLE IF NOT EXISTS `" || THE_TABLE || "` (name, line);"
  FROM THE_CALL
UNION ALL
SELECT "WITH split(word, str) AS (
    SELECT '', readfile('" || THE_FILENAME || "') || CHAR(10)
    UNION ALL
    SELECT
        substr(str, 0, instr(str, CHAR(10))),
        substr(str, instr(str, CHAR(10))+1)
    FROM split
    WHERE str!=''
) INSERT INTO `" || THE_TABLE || "` SELECT """ || THE_FILENAME || """, word FROM split;"
 FROM THE_call;
 
.read .sqlite_temp/docall2.out
