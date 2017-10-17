# TODO

Version : Viper 1.99-rc0

Major reimplementation of Statement class
  >> current thing stands in for def call
  >> implements alias and non-alias statements w/redirection and variable assignments
  >> TODO: handle recursive alias references
  >> alias foo=bar; alias bar=baz; alias baz=foo
  >> 'foo' will raise new RecursiveAliasError


Major Bug:
  >> Use character traits in current buffer ??!??!!!
Uber BUG: should not use subshells like there are candy
  >> E.g.
  >> (key_exists :key && apply :key) || echo bad juju
  >> above construct was a cheap if/then/else statement
  >> Instead use:
  >> exec { key_exists :key && apply :key } || echo bad juju
  >> Eventually, the bare '{statement1;statement2}' construct will work in parser for Vish removing need for exec
Bug: no method error in meta_semicolon (internal command mode)  and using up arrow.
Bug: sometimes quitting when unsaved dirty buffers errors in echo command
Bug: sometimes get no method for NilClass, esp when scripts/at_exit/001_shutdown.vsh
Bug: Get Command not found when at end oof buffer and try to do any movements in that direction
Bug: Should global variable first unset variable so any pushed frame stacks unset it as well?
  >> Check out in Bash first, remember that it uses local instead of global

Bug/Feature: Investigate how to properly handle option errors
Bug:feature: Make sure echo >> :_buf works esp. with tests
Bug:/Feature: Need tests for frame_stack.rb - Has many methods
  >> in OptionParser - w/custom error handler
Feature: unset -f option needed to delete a declared fucton.
Feature: del_line :_buf to delete a line. Outputs line to stdout
Feature: To implement scratch: Use -e scratch
alias scratch='vn -e scratch'

 Feature: Make this expression parsable in  Vish:
   >> { echo hello } > file.txt
     >> This construct should be at same level as SubShell (and also take redirections
       >> ... add method ordinal to Block. it should return  COMMAND
  >> But : requires changes to Vish grammar file.
Feature: Use of :__FUNCTION_NAME__ for the name of the function itself within a function
  >> can represents the name of the function itself. E.g. Bash echo $0 within a function
  >> In the case of a lambda expression, reports 'anonymous' when executed.
Feature: Use of :__FUNCTION__ is true if in a function.
Feature : Use of __FUNCTION_TYPE__ as either function or lambda.
  >> is blank otherwise
  >> Will be true in ivish (interactive Vish) and within  command prompt
Bug: better error handle of trying to open a directory
Current Task:

A. Make test/all_test.vsh work within bin/viper
    >>>> Make kpeg compile work within lib/vish
  >> Copy old debugging support to somewhere



Notes:
:: objects returned from various ...Facade  class, must implement the print method (and the write method?)

Remember Vish is a Bash-clone: This means spaces are significant esp. when dereferencing variables
  >> Can sometimes overcome this by placing in double quotes: :result vs. ":{result}"
  >> This also applies to read command and also subshell expansion
  >> Can use :ifs to be some other value than ' '; E.g.: ifs='x' read result
# disabled the LineLength cop for this one section of code
# rubocop:disable Lint/UnusedBlockArgument
#->(env: _, frames: _) { puts }

Addded  keys:
# indenting/outdenting, commenting commands:
in <mark> will indent to previous mark
out <mark> will outdent to previous mark
cmt <mark> will comment all lines to previous mark

# Evaluate buffer:
In command mode: 
evalvsh - Will parse and evaluate contents of buffer: :_buf
echo some Vish stuff | vsh_parse varname - ; eval :varname - parse and evaluate stdin
Have added meta_period to repeat the last command.
> m <mark name> - sets given mark at current position. Can be reused with meta_period


meta_d captures key, _clip and _sup for undo and macro playback
Added meta_p: reports absolute current position
In interactive Vish shell:
  > exit_status is ppreserved in :_status

test command can now take no options and set :_status, :exit_status based on first argument
test -l checks if first arg is a Lambda

In normal viper editor:
Use 'vish' fn to enter into interactive shell from command mode
  >> Use 'vip' to return to viper mode in current buffer


F3, fn_3 reports on existing meta modes. Changed from meta_m

Investigations:
Investigate: Is Vsh redundant for eval statement?
  > If so, then replace vsh w/eval
# --
Outstanding bugs, new features
Bug: -c does not work to check .vsh syntax ... investigate
Bug: in command mode/commander mode: ctrl_d should not just push vip on modestack
  > Should enter vip or exit onto last line of /v/command buffer
  > Then apply ctrl_m so correct thing happens in loop
Feature: Remove buf_node: BufNode < VFSNode.
  >> make mkbuf extend mknode or mkdir and add new Buffer to buffer key
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

## New keys

Meta N : Prompts for a key and inserts it at the current cursor position without advancing the cursor.
>> Bug: Missing properly key logging method.
