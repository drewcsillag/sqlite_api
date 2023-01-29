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

CREATE TABLE api.help(
    command,
    args,
    docstring);

INSERT INTO api.help VALUES
   ('json_explode_arr', 'src_tbl src_column dest_tbl', 'explode json arrays into a table'),
   ('json_explode_obj', 'src_tbl src_column dest_tbl', 'explode json objects into a table'),
   ('loadlines', 'filename dest_tbl', 'load filename into a table'),
   ('loadlines_colon', 'filename new_tbl', 'load filename with colon delimiter into a table'),
   ('noop', null, 'do nothing'),
   ('print', 'thing_to_print', 'print the thing'),
   ('shellcmd', 'dest_tbl command', 'execute command and store output in dest_tbl'),
   ('pipecolumn', 'src_tbl src_column trim? new_tbl command',
      'run command against the input creating new_tbl with outputs. If trim? is 1, '
      || 't or T it will right trim off trailing carriage returns and/or newlines'),
   ('split_on_colon', 'src_tbl carry_over_cols split_col dest_tbl dest_col',
      'split src_tbl split_col on colon and carry over carry_over_cols columns into dest_tbl, '
      || 'with the new column being dest_col');
