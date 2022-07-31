-- arg 1 table
-- arg 2 col
-- arg 3 new table

-- generate
-- CREATE TABLE THE_NEW_TABLE AS SELECT je.value FROM json_each(z.THE_COLUMN) je, THE_TABLE z;

-- .once .sqlite_temp/docall2.out
SELECT a FROM ( -- to inhibit the output of writefile
SELECT writefile('.sqlite_temp/docall2.out', line) a FROM (

WITH THE_CALL AS (
    SELECT arg1 AS THE_TABLE, arg2 AS THE_COLUMN, arg3 AS THE_NEW_TABLE
    FROM api._call
     )
SELECT "CREATE TABLE IF NOT EXISTS `" || THE_NEW_TABLE || "` AS
    SELECT z.rowid as src_rowid, je.value
    FROM json_each(z.`" || THE_COLUMN || "`) je, `" || THE_TABLE || "` z 
    WHERE json_valid(z.`" || THE_COLUMN || "`)
      AND 'array' = json_type(z.`" || THE_COLUMN || "`);" as line
FROM THE_CALL
)) WHERE a = 0
;
.read .sqlite_temp/docall2.out
