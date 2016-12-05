# TODO

Version : vish.0.2.4
Outstanding bugs:

Bug: introduced new problem in shutdown.vsh, having to do with  prompt mode
Bug: Finally fix bug in VirtualLayer[ ... anything except * ...] returns nil for VfsNode/Root
Bug: backslash character is doing what fn_2 :F2 is doing and not putting backslash
Feature: Syntax checker for .vsh buffers
Feature: complete coding of undo/redo:
> handle backspace, forward delete, cut, copy, paste, cursor movement, etc.
Bug: echos extra new line after typing search term and returning to vip mode
> Also occurs in Command mode
Bug: line_number is often incremented by one or more for some reason
Make com, when raised in commander, be able to return to previous mode
Make Vsh able to set variables in global environment, w/o requireing global expression

