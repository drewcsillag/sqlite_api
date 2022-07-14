ATTACH DATABASE ':memory:' as api;
CREATE TABLE IF NOT EXISTS api._call (
   func, arg1, arg2, arg3);
   
CREATE TABLE IF NOT EXISTS api.call (
   func, arg1, arg2, arg3);
