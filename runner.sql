-- a simple test to make sure everything works
.read api_init.sql

create table foo (line text);
insert into foo values 
    ('foo'),
    ('--'),
    ('bar'),
    ('baz'),
    ('fred'),
    ('--'),
    ('barney');

insert into api.command VALUES
   ('loadlines alltogether.txt b null'),
   ('json_explode_arr b line bs'),
   ('json_explode_obj bs value battrs'),
   ('cluster foo line clustered maybe_delimiter == ''--''');

.read api.sql
