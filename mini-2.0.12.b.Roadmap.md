# Mini Roadmap for Version 2.0.12.b

## Abstract

This documents expands on the work needed to finish 2.0.12b



## REPL

In vish.rb: Use of Ruby StdLib 'reline'

Use new class ReplPDA inside the def repl method

- checkmark:

Understand signalling in reline library.

### How do I get a $PS2 -like functionality when multiline input proc returns false?


Control-C works, but Ctrl-D does not
Ctrl-A for goto beginning of line and ctrl-e goto end of line works, but ctrl-u does not
Need to understand how to handle errors
Maybe beep the bell?



## :argc, :argv parsing

System startup

./local/vish/bin/boot.vsh =>
   ./local/etc/vishrc =>
     ./local/vish/prelude.vsh =>
        ./local/vish/prelude/001_argparse.vsh


The final step processes Ruby's ARGV into :argc and :argv

Note: can add any more things to ./local/vish/prelude/00?_*.vsh as needed.


