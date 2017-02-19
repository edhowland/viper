# TODO

Version : vish.0.3.0

Notes:
Addded  keys:
  meta_less - bound to outdent range
  meta_greater - bound to indent range
  meta_number - will be bound to comment range
indenting/outdenting, commenting commands:
in <mark> will indent to previous mark
out <mark> will outdent to previous mark
cmt <mark> will comment all lines to previous mark
Evaluate buffer:
In command mode: 
evalvsh - Will parse and evaluate contents of buffer: :_buf
echo some Vish stuff | vsh_parse varname - ; eval :varname - parse and evaluate stdin
Have added meta_period to repeat the last command.
> m <mark name> - sets given mark at current position. Can be reused with meta_period

> added meta_r, meta_f to goto previous, next mark based on :_mark
> These can be undone/redone
> Added meta_m + (printable) - sets named mark at current char

meta_d captures key, _clip and _sup for undo and macro playback
Added meta_p: reports absolute current position
In interactive Vish shell:
  > exit_status is ppreserved in :_status

test command can now take no options and set :_status, :exit_status based on first argument
test -l checks if first arg is a Lambda

Use 'vish' fn to enter into interactive shell from command mode
  > Use 'vip' to return to viper mode in current buffer

meta+d, c will call fn clear_line. clears contents of line without deleting the line
  > For future use in ctrl_d in command mode

F3, fn_3 reports on existing meta modes. Changed from meta_m

Investigations:
Investigate: Is Vsh redundant for eval statement?
  > If so, then replace vsh w/eval
----
Outstanding bugs, new features
Bug: when scratch buffer(s) in use: and non_-empty, they cannot be saved to file names
  > Possibly, have a modal dialog base to get filename from user
Bug: problem with/backspace saying selection deleted. sometimes
Bug: in command mode/commander mode: ctrl_d should not just push vip on modestack
  > Should enter vip or exit onto last line of /v/command buffer
  > Then apply ctrl_m so correct thing happens in loop
Feature/Bug: Make the echo be both builtin and a real command in /v/bin.
  >> This conforms to Bash like behaviour.
Feature: add -f option to unset command to remove functions
  > Possible enhancement: allow for the function hash to be a part of the frame stack
  > ... Would for functions to within functions, and go out of scope when left
  > ... Also, allow for blocks, lambdas to contain them and called externally
  > ... By some dot '.' notation (whithin grammar?)
Feature: in scripts/*.vsh: move cut, copy and paste to scripts/editor.vsh
Feature: when logging  meta_c, in addition to remembering :_clip, 
  > How would this affect other things in undo actions?
Feature: meta_c +  move_shift_end => copy to end of line
  > meta_c + move_shift_home => copy to front of line
  > meta_c + move_shift_pgup => copy to top of buffer
  > meta_c + move_shift_pgdn => copy to end of buffer
  > meta_c + w => copy word forward
  > meta_c + W => copy word back
Feature: Implement ins_fwd method in api/buffer.rb
Feature: comment/uncomment blocks that are marked
  > Use comment style as defined by .ext. E.g. .rb => '#'. .js => '//'
  > Work at current indent level
Feature: Implement simple lint checker, like in Viper version 1.x


Feature: complete coding of undo/redo:
  > keep checking on possible undo stuff ...
  > such as after run_snip, via handle_tab

