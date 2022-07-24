.once .sqlite_temp/docall0.out
.mode

.mode list

.once .sqlite_temp/docalls.out
SELECT 
"
----- Move first record from api.call to api._call
INSERT INTO api._call
WITH config AS (
    SELECT COALESCE( (SELECT path FROM api.config), './') AS path
)
  SELECT func, arg1, arg2, arg3, arg4 FROM api.call, (SELECT MIN(rowid) AS m FROM api.call) fmin WHERE fmin.m = api.call.rowid;
.once .sqlite_temp/docall1.out
SELECT '.read ' || (SELECT COALESCE( (SELECT path FROM api.config), './') AS path) || 'call_' || func || '.sql' from api._call;
.read .sqlite_temp/docall1.out
DELETE from api._call;
DELETE from api.call WHERE rowid = (select min(rowid) from api.call);
----- End of instruction
"
FROM api.call;
.read .sqlite_temp/docalls.out


.once .sqlite_temp/docall1.out
WITH config AS (
    SELECT COALESCE( (SELECT path FROM api.config), './') AS path
)
SELECT '
----- Read file for the function
.read ' || (SELECT COALESCE( (SELECT path FROM api.config), './') AS path) || 'call_' || func || '.sql
----- End of function .read
' from api._call;
.read .sqlite_temp/docall1.out
DELETE from api._call;

.once .sqlite_temp/docall0-1.out
WITH inds AS (
    SELECT p, instr(p, char(10)) as cr, instr(p, ':') + 2 AS modestart 
    FROM (
        SELECT readfile('.sqlite_temp/docall0.out') AS p
    )
) SELECT '.mode ' || substr(p, modestart, cr-modestart) 
  FROM inds;
.read .sqlite_temp/docall0-1.out