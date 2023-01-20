SELECT "-------------
sqlite_commands help:

insert lines into api.command of the following form:

help -- this help
json_explode_arr src_tbl src_column dest_tbl -- explode json arrays into a table
json_explode_obj src_tbl src_column dest_tbl -- explode json objects into a table
loadlines filename dest_tbl  -- load filename into a table
loadlines_colon filename new_tbl -- load filename with colon delimiter into a table
noop -- do nothing
print thing_to_print -- print a token
shell dest_tbl command -- execute command and store output in dest_tbl
split_on_colon src_tbl carry_over_cols split_col dest_tbl dest_col -- split src_tbl split_col on colon
 and carry over carry_over_cols columns into dest_tbl, with the new column being dest_col
"