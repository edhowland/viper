# TODO

Version : vish.0.2.4

Notes:
In interactive Vish shell:
  > exit_status is ppreserved in :_status


test command can now take no options and set :_status, :exit_status based on first argument

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

Bug: echos extra new line after typing search term and returning to vip mode
> Also occurs in Command mode
Make com, when raised in commander, be able to return to previous mode
