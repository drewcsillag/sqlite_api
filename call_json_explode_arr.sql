-- arg1 table
-- arg 2 col
-- arg 3 new table

-- generate
-- CREATE TABLE THE_NEW_TABLE AS SELECT je.value FROM json_each(z.THE_COLUMN) je, THE_TABLE z;
.once docall2.out
WITH THE_CALL AS (
    SELECT arg1 AS THE_TABLE, arg2 AS THE_COLUMN, arg3 AS THE_NEW_TABLE
    FROM api._call
     )
SELECT "CREATE TABLE `" || THE_NEW_TABLE || "` AS
    SELECT z.rowid as src_rowid, je.value
    FROM json_each(z.`" || THE_COLUMN || "`) je, `" || THE_TABLE || "` z;"
FROM THE_CALL;
.read docall2.out
