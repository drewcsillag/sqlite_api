
SELECT a FROM ( -- to inhibit the output of writefile
SELECT writefile('.sqlite_temp/docalls.out', group_concat(lines.block, char(10))) a -- group_concat to glue
FROM (
  SELECT 0 as key,
"
----- Move first record from api.call to api._call
INSERT INTO api._call
WITH config AS (
    SELECT COALESCE( (SELECT path FROM api.config), './') AS path
)
  SELECT func, arg1, arg2, arg3, arg4, arg5 FROM api.call, (SELECT MIN(rowid) AS m 
  FROM api.call) fmin WHERE fmin.m = api.call.rowid;
SELECT a FROM ( -- to inhibit the output of writefile
SELECT writefile('.sqlite_temp/docall1.out', line) a FROM (
  SELECT '.read ' || (SELECT COALESCE( (SELECT path FROM api.config), './') AS path) || 'call_' || func || '.sql' AS line from api._call
))
WHERE a = 0;
.read .sqlite_temp/docall1.out
DELETE from api._call;
DELETE from api.call WHERE rowid = (select min(rowid) from api.call);
----- End of instruction
" as block 
FROM api.call
) lines
GROUP BY key
) WHERE a = 0;
.read .sqlite_temp/docalls.out


-- .once .sqlite_temp/docall1.out

-- SELECT a FROM ( -- to inhibit the output of writefile
-- SELECT writefile('.sqlite_temp/docall1.out', line) a FROM (
-- WITH config AS (
--     SELECT COALESCE( (SELECT path FROM api.config), './') AS path
-- )
-- SELECT '
-- ----- Read file for the function
-- .read ' || (SELECT COALESCE( (SELECT path FROM api.config), './') AS path) || 'call_' || func || '.sql
-- ----- End of function .read
-- ' as line from api._call)) WHERE a = 0;

-- .read .sqlite_temp/docall1.out
-- DELETE from api._call;