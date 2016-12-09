# TODO

Version : vish.0.2.4

Outstanding bugs, new features

Feature:  change dirty check to depend on computed message digest
Bug: screwed up handle_tab, but run_snip still works
Feature: undo key_backspace get contents from passed :_clip buffer

Bug: introduced new problem in shutdown.vsh, having to do with  prompt mode
Feature: Syntax checker for .vsh buffers
Feature: complete coding of undo/redo:
> handle backspace, forward delete,    ... etc.
Bug: echos extra new line after typing search term and returning to vip mode
> Also occurs in Command mode
Bug: line_number is often incremented by one or more for some reason
Make com, when raised in commander, be able to return to previous mode
Make Vsh able to set variables in global environment, w/o requireing global expression

