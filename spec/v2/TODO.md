# TODO

Version : vish.0.2.4

Outstanding bugs, new features

Bug: screwed up handle_tab, but run_snip still works
Feature: undo key_backspace get contents from passed :_clip buffer

Feature: Syntax checker for .vsh buffers
Feature: complete coding of undo/redo:
> handle backspace, forward delete,    ... etc.
Bug: echos extra new line after typing search term and returning to vip mode
> Also occurs in Command mode
Make com, when raised in commander, be able to return to previous mode
Make Vsh able to set variables in global environment, w/o requireing global expression
  > probably need to execute input in context of vm, not block just parsed

