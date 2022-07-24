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

SELECT a FROM ( -- to inhibit the output of writefile
SELECT writefile('.sqlite_temp/docall2.out', group_concat(lines.block, char(10))) a -- group_concat to glue
FROM (

WITH THE_CALL AS (
   -- rename the args to things that make it easier to see what's going on below
   SELECT arg1 AS THE_TABLE, arg2 AS THE_COLUMN, arg3 AS THE_NEW_TABLE,
      -- filter out empty objects when configured to do so
      CASE WHEN arg4 is NULL 
      THEN "" 
      ELSE " AND `" || arg2 || "` != ''{}''"
      END AS THE_WHERE
    FROM api._call
    )
     
SELECT 0 AS key, "
.once .sqlite_temp/docall3.out
WITH de AS (
  -- get the set of top level keys
  SELECT
    distinct(je.key)
  FROM
    `" || THE_TABLE || "`,
    json_each(`" || THE_TABLE || "`.`" || THE_COLUMN || "`) je
  WHERE
    json_valid(`" || THE_TABLE || "`.`" || THE_COLUMN || "`)
    AND 'object' = json_type(`" || THE_TABLE || "`.`" || THE_COLUMN || "`)
  ORDER BY
    je.key
)
SELECT
  'CREATE TABLE `" || THE_NEW_TABLE || "` (
      src_rowid INTEGER, ' || group_concat('`' || key || '` TEXT', ', ')
      || ', FOREIGN KEY(src_rowid) REFERENCES `" || THE_TABLE || "`(`" || THE_COLUMN || "`));'
from
  de
UNION ALL
SELECT
  'INSERT INTO " || THE_NEW_TABLE || " SELECT rowid, ' || group_concat('json_extract(`" || THE_COLUMN 
      || "`, ''$.""' || key || '""'')', ', ') || ' FROM `" || THE_TABLE
      || "` WHERE json_valid(`" || THE_TABLE || "`.`" || THE_COLUMN
      || "`) AND json_type(`" || THE_TABLE || "`.`" || THE_COLUMN || "`) = ''object''" || THE_WHERE || ";'
 FROM
   de;" AS block
  from THE_CALL
UNION ALL
SELECT 0, '.read .sqlite_temp/docall3.out'
) lines
GROUP BY key
) WHERE a = 0;
;

.read .sqlite_temp/docall2.out
