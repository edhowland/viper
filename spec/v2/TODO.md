# TODO

Version : vish.0.2.4

Outstanding bugs, new features

Bug: screwed up handle_tab, but run_snip still works

Feature: Syntax checker for .vsh buffers
Feature: complete coding of undo/redo:
  > keep checking on possible undo stuff ...
  > such as after run_snip, via handle_tab

Bug: echos extra new line after typing search term and returning to vip mode
> Also occurs in Command mode
Make com, when raised in commander, be able to return to previous mode
Make Vsh able to set variables in global environment, w/o requireing global expression
  > probably need to execute input in context of vm, not block just parsed

