-- arg1 THE_TABLE
-- arg2 THE_COLUMN
-- arg3 NEW_TABLE
-- 
-- -- .once docall2.out
-- WITH de AS (
--   SELECT
--     distinct(je.key)
--   FROM
--     THE_TABLE,
--     json_each(`THE_TABLE`.`THE_COLUMN`) je
--   WHERE
--     json_valid(`THE_TABLE.`THE_COLUMN`)
--   ORDER BY
--     je.key
-- )
-- SELECT
--   'CREATE TABLE `NEW_TABLE` (src_rowid INTEGER, ' || group_concat('`' || key || '` TEXT', ', ') || ');'
-- from
--   de
-- UNION ALL
-- SELECT
--   'INSERT INTO NEW_TABLE SELECT rowid, ' || group_concat('json_extract(`THE_COLUMN`, ''$.' || key || ''')', ', ') || ' from `THE_TABLE`;'
-- FROM
--   de;
-- -- .read docall2.out

.once docall2.out
WITH THE_CALL AS (
   SELECT arg1 AS THE_TABLE, arg2 AS THE_COLUMN, arg3 AS THE_NEW_TABLE
     FROM api._call
     )
     
SELECT "
.once docall3.out
WITH de AS (
  SELECT
    distinct(je.key)
  FROM
    " || THE_TABLE || ",
    json_each(`" || THE_TABLE || "`.`" || THE_COLUMN || "`) je
  WHERE
    json_valid(`" || THE_TABLE || "`.`" || THE_COLUMN || "`)
  ORDER BY
    je.key
)
SELECT
  'CREATE TABLE `" || THE_NEW_TABLE || "` (src_rowid INTEGER, ' || group_concat('`' || key || '` TEXT', ', ') || ', FOREIGN KEY(src_rowid) REFERENCES `" || THE_TABLE || "`(`" || THE_COLUMN || "`));'
from
  de
UNION ALL
SELECT
  'INSERT INTO " || THE_NEW_TABLE || " SELECT rowid, ' || group_concat('json_extract(`" || THE_COLUMN || "`, ''$.' || key || ''')', ', ') || ' from `" || THE_TABLE || "`;'
 FROM
   de;"
  from THE_CALL
UNION ALL
SELECT '.read docall3.out';

.read docall2.out
