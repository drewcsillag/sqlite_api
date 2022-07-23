ATTACH DATABASE ':memory:' as api;
CREATE TABLE api._call (
   func, arg1, arg2, arg3);
   
CREATE TABLE api.call (
   func, arg1, arg2, arg3);

CREATE TABLE api.config(
    path);