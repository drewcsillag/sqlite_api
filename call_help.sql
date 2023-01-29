SELECT "-------------
sqlite_commands help:

insert lines into api.command of the following form:

help -- this help"
UNION ALL
SELECT GROUP_CONCAT(command || coalesce(" " || args, "") || " -- " || docstring , CHAR(10)||CHAR(13)) from api.help;