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

checkmark

Ctrl-A for goto beginning of line and ctrl-e goto end of line works, but ctrl-u does not
Need to understand how to handle errors
Maybe beep the bell?



## :argc, :argv parsing

System startup

./local/vish/bin/boot.vsh =>
   ./local/etc/vishrc =>
     ./local/vish/prelude.vsh =>
        ./local/vish/prelude/001_argparse.vsh
        ./local/vish/prelude/002_import.vsh




The final step processes Ruby's ARGV into :argc and :argv

Note: can add  more things to ./local/vish/prelude/00?_*.vsh as needed.




### Importing modules

./local/vish/modules/*

In Vish:

```
import my_module
```

All 00_1_*.vsh files in ./local/vish/modules/my_module
will be sourced.

## Option parsing

- simple option parser
- [potentential] complex option parser
  * with lambdas if the option has been seen in :argv

### Simple option parser

/v/options/[__FILE__]/{expected,actual,help}

- empty files  in expected signify a boolean flag
- directories in expected signify a a value option

When scanning the :argv, if a option is found to be a boolean flag in expected, then it is touched in actual
If the expected match is a dir, the dir is created in actual and and the next
item to be scanned is touched within that dir.

If a flag is detected, but not in the expected dir, thenan exception is raised with a message

The help dir is only full of Markdown files matching the option keys

The -h, (and someday the --help) is automatically generated. It is a stored lambda
that a closure over the path to this option.
When invoked, it scans the help folders and just cats the  Markdown files
after first printing the -o option string with no new line.
