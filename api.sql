
.once docall.out
SELECT '.read call_' || func || '.sql' from api._call;
.read docall.out
DELETE from api._call;
