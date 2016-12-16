# TODO

Version : vish.0.2.4

Notes:

Currently working on api/character_traits.rb - refinement to string to add 
  > traits to string chars
  > Aded within :_buf p1 p2 - outputs content between p1 and p2
  > For eventual use in new copy method using  traits as bookmarks, marks


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


Use 'vish' fn to enter into interactive shell from command mode
  > Use 'vip' to return to viper mode in current buffer

meta+d, c will call fn clear_line. clears contents of line without deleting the line
  > For future use in ctrl_d in command mode

F3, fn_3 reports on existing meta modes. Changed from meta_m

Outstanding bugs, new features

Bug: cannot search with embedded spaces.
  > probably due to splitting into multiple arguments to command
  > Possible fix is to rework srch_fwd, back to gather args into a single arg
Bug: problem with/backspace saying selection deleted. sometimes
Bug: in command mode/commander mode: ctrl_d should not just push vip on modestack
  < Should enter vip or exit onto last line of /v/command buffer
  > Then apply ctrl_m so correct thing happens in loop
Feature: when logging  meta_c, in addition to remembering :_clip, 
Feature: in play_macro: look for up to 3 fields for things like meta_d,:_clip,:_sup to playback real thing
  > /v/modes/macros/meta_d &(data) { ... figure this out. data is NOT the supplemental char
  > Possibly switch :_clip,:_sup to ,:_sup,:_clip instead
  > How would this affect other things in undo actions?
> also remember :_sup for supplemental key. This is the second key struck.
Feature: meta_c +  move_shift_end => copy to end of line
  > meta_c + move_shift_home => copy to front of line
  > meta_c + move_shift_pgup => copy to top of buffer
  > meta_c + move_shift_pgdn => copy to end of buffer
  > meta_c + w => copy word forward
  > meta_c + W => copy word back
Feature: Implement ins_fwd method in api/buffer.rb
Feature: indent/outdent marked range
Feature: comment/uncomment blocks that are marked
  > Use comment style as defined by .ext. E.g. .rb => '#'. .js => '//'
  > Work at current indent level
Feature: Implement simple lint checker, like in Viper version 1.x
Bug:  > and whenever this occurs
  > caught exception : undefined method `split' for false:FalseClass
  > ... Usually means virtual path does not exist like echo -n :word > :_clip
  > like before first new_clip has been executed


Feature: Syntax checker for .vsh buffers
Feature: complete coding of undo/redo:
  > keep checking on possible undo stuff ...
  > such as after run_snip, via handle_tab

