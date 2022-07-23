.mode list

.once docalls.out
SELECT 
"INSERT INTO api._call
WITH config AS (
    SELECT COALESCE( (SELECT path FROM api.config), '.') AS path
)
  SELECT func, arg1, arg2, arg3 FROM api.call, (SELECT MIN(rowid) AS m FROM api.call) fmin WHERE fmin.m = api.call.rowid;
.once docall1.out
SELECT '.read ' || (SELECT path FROM config) || 'call_' || func || '.sql' from api._call;
.read docall1.out
DELETE from api._call;
DELETE from api.call WHERE rowid = (select min(rowid) from api.call);
"
FROM api.call;
.read docalls.out


.once docall1.out
WITH config AS (
    SELECT COALESCE( (SELECT path FROM api.config), '.') AS path
)
SELECT '.read ' || (SELECT path FROM config) || 'call_' || func || '.sql' from api._call;
.read docall1.out
DELETE from api._call;
