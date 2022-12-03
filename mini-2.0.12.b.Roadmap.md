# Mini Roadmap for Version 2.0.12.b

## Abstract

This documents expands on the work needed to finish 2.0.12b



## REPL

In vish.rb: Use of Ruby StdLib 'reline'

Use new class ReplPDA inside the def repl method

- checkmark:

Understand signalling in reline library.

Control-C works, but Ctrl-D does not
Ctrl-A for goto beginning of line and ctrl-e goto end of line works, but ctrl-u does not
Need to understand how to handle errors
Maybe beep the bell?

