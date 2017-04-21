# TODO

Version : Viper 1.99-rc0

Rubocop stuff
command: rubo.todo.cop
individual command: rubo.todo.cop -D lib/... /... .rb
Current line in .rubocop_todo.yml:
~ 155 
Add tests for rangify
--- Skipping over global variables for now


Major Bug:
Bug: Going to end of command buffer raises uncaught BufferExceeded
Bug: :oldpwd is not being set. also cd - does not work
  >> :oldpwd is being set to :pwd after cd ...

Bug/Feature: Investigate how to properly handle option errors
Bug:/Feature: Need tests for frame_stack.rb - Has many methods
  >> in OptionParser - w/custom error handler
Bug: find command does not work properly
Bug: Cannot edit two buffers from the same file name, but different directories
  >> This is because /v/buf/Rakefile is only a single pathname:
  >> constructed by : filename.ext of original pathname prepended with /v/buf/
  >> Possible fix:  append '_2', '_3' ... for subsequent buffer pathnames

Bug: better error handle of trying to open a directory
Current Task:

A. Make test/all_test.vsh work within bin/viper
  >> Move attic/Rakefile to ./Rakefile. 
    >>>> Make kpeg compile work within lib/vish
    >>>> Check current Rakefile for things... Probably just runs old specs
  >> Copy old debugging support to somewhere



Notes:
Should implement pwd method in lib/runtime/hal.rb via method_missing
:: objects returned from various ...Facade  class, must implement the print method (and the write method?)

Remember Vish is a Bash-clone: This means spaces are significant esp. when dereferencing variables
  >> Can sometimes overcome this by placing in double quotes: :result vs. ":{result}"
  >> This also applies to read command and also subshell expansion
  >> Can use :ifs to be some other value than ' '; E.g.: ifs='x' read result
# disabled the LineLength cop for this one section of code
# rubocop:disable Lint/UnusedBlockArgument
#->(env: _, frames: _) { puts }

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

In normal viper editor:
Use 'vish' fn to enter into interactive shell from command mode
  >> Use 'vip' to return to viper mode in current buffer

meta+d, c will call fn clear_line. clears contents of line without deleting the line
  > For future use in ctrl_d in command mode

F3, fn_3 reports on existing meta modes. Changed from meta_m

Investigations:
Investigate: Is Vsh redundant for eval statement?
  > If so, then replace vsh w/eval
----
Outstanding bugs, new features
Bug: -c does not work to check .vsh syntax ... investigate
Bug: in command mode/commander mode: ctrl_d should not just push vip on modestack
  > Should enter vip or exit onto last line of /v/command buffer
  > Then apply ctrl_m so correct thing happens in loop
Feature: Remove buf_node: BufNode < VFSNode.
  >> make mkbuf extend mknode or mkdir and add new Buffer to buffer key
Feature/Bug: Make the echo be both builtin and a real command in /v/bin.
  >> This conforms to Bash like behaviour.
Feature: add -f option to unset command to remove functions
  > Possible enhancement: allow for the function hash to be a part of the frame stack
  > ... Would for functions to within functions, and go out of scope when left
  > ... Also, allow for blocks, lambdas to contain them and called externally
  > ... By some dot '.' notation (whithin grammar?)
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


Feature: complete coding of undo/redo:
  > keep checking on possible undo stuff ...
  > such as after run_snip, via handle_tab

