ATTACH DATABASE ':memory' as api; -- api.db' AS api;
CREATE TABLE IF NOT EXISTS api._call (
   func, arg1, arg2, arg3);
