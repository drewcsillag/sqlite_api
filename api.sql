----- If there's anything in api.commands, convert them to api.call
INSERT INTO api.call
SELECT func, arg1, arg2, arg3, arg4, arg5 
FROM
(
    -- handle everything but 'clustered'
    SELECT
        rowid,
        json_extract(j, '$[0]') as func,
        json_extract(j, '$[1]') as arg1,
        json_extract(j, '$[2]') as arg2,
        json_extract(j, '$[3]') as arg3,
        json_extract(j, '$[4]') as arg4,
        json_extract(j, '$[5]') as arg5
    FROM (
        SELECT rowid, '["' || REPLACE(command, ' ', '","') || '"]' AS j FROM api.command
        WHERE substr(command,1,8) != 'cluster '
    )

    UNION ALL

    -- handle the 'clustered' case
    SELECT
        rowid,
        func,
        arg1,
        arg2,
        substr(rest, 1, instr(rest, ' ') - 1) AS arg3,
        substr(rest, instr(rest, ' ') + 1) AS arg4,
        null as arg5
    FROM (
        SELECT 
            rowid,
            func, 
            arg1,
            substr(rest, 1, instr(rest, ' ') - 1) AS arg2,
            substr(rest, instr(rest, ' ') + 1) AS rest 
        FROM (
            SELECT 
                rowid, 
                func, 
                substr(rest, 1, instr(rest, ' ') - 1) AS arg1,
                substr(rest, instr(rest, ' ') + 1) AS rest 
            FROM (
                SELECT rowid, substr(command, 1, instr(command, ' ')-1) AS func,
                    substr(command, instr(command, ' ') + 1 ) AS rest from command
                WHERE substr(command,1,8) == 'cluster '
            )
        )
    )

) order by rowid;


DELETE FROM api.command;

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