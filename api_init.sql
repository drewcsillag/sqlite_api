ATTACH DATABASE ':memory:' as api;
-- where x=1 bit to inhibit a 0 getting written to the terminal
SELECT * from (SELECT writefile('.sqlite_temp/marker', '') as x) WHERE x=1;

CREATE TABLE api._call (
   func, arg1, arg2, arg3, arg4, arg5);
   
CREATE TABLE api.call (
   func, arg1, arg2, arg3, arg4, arg5);

CREATE TABLE api.config(
    path);

CREATE TABLE api.command(
    command);