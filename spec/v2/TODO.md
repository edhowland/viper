# TODO

Version : vish.0.2.4

Notes:
In interactive Vish shell:
  > exit_status is ppreserved in :_status


test command can now take no options and set :_status, :exit_status based on first argument


Use 'vish' fn to enter into interactive shell from command mode
  > Use 'vip' to return to viper mode in current buffer

Outstanding bugs, new features

Feature: indent/outdent marked range
Feature: Implement simple lint checker, like in Viper version 1.x
Bug:  > and whenever this occurs
  > caught exception : undefined method `split' for false:FalseClass
  > ... Usually means virtual path does not exist like echo -n :word > :_clip
  > like before first new_clip has been executed


Feature: Syntax checker for .vsh buffers
Feature: complete coding of undo/redo:
  > keep checking on possible undo stuff ...
  > such as after run_snip, via handle_tab

