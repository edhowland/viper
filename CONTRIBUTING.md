# CONTRIBUTING.md


## First: Thanks for Contributing!


This file lists some guidelines for contributing to the Viper Editor project on GitHub.
The entire Viper project is hosted at [https://github.com/edhowland/viper](https://github.com/edhowland/viper)
These are just guidelines, not rules, use your best judgment and feel free to propose changes to this document in a pull request. 



### Source of this document.


This document borrows heavily from the CONTRIBUTING.md for the Atom editor on GitHub.com Source:  [https://github.com/atom/atom/blob/master/CONTRIBUTING.md](https://github.com/atom/atom/blob/master/CONTRIBUTING.md)


[Where should I begin?](#Where-should-I-begin?)





## Where should I begin?




### Code of Conduct


Please read the [Code of Conduct](CODE_OF_CONDUCT). before proceeding.

### You might also be interested in my philosophy of programming and project management:

[Philosophy.md](Philosophy.md)



### Viper development environment


Viper is coded in Ruby 2 and 3, so you should also have a complete Ruby development toolchain. If you can already run Viper,
you probably can also begin to develop for Viper

## Reporting Bugs 

Please use the GitHub issue tracker at [https://github.com/edhowland/viper/issues](https://github.com/edhowland/viper/issues) 

## Pull Requests 

Before submitting a PR, make sure the following steps complete successfully:

1. Run all specs in the spec/ folder.
2. Run Rubocop with supplied .rubocop_todo.yml configuration file.
3. Run simplecov to reproduce code coverage.


### Rake spec


In the top level directory, viper, run 'rake'. All tests should pass with no failures, errors or skips.



### Rubocop


Viper attempts to adhere to the Ruby style guide as used by the Rubocop lint checker. Currently there some configuration settings in the top level
viper directory. The file is .rubocop_todo.yml
You can run rubocop with this configuration with the following command:


```
rubocop --config ./.rubocop_todo.yml
```


You should get no offenses listed. If you do, however, use the diagnostics to investigate the trouble. Here are the links for Rubocop on GitHub:

[Rubocop](https://github.com/bbatsov/rubocop)
[Rubocop Ruby Style Guide](https://github.com/bbatsov/ruby-style-guide)


### simplecov for Code coverage.


To reproduce the simplecov coverage report:


```
# In the top level directory: viper/

  $ COV=1 rake
```


This will generate a coverage.json file in coverage/coverage.json.
You can use Viper itself to view and interact with the coverage report. See README.md for details.
You should get 95% - 100% coverage before submitting your pull request.



## Git branches


The stable branch is 'master'. There may be release branches hosted on the GitHub repository. Use these with caution. The current version of Viper
is 0.9.7. You can always get the latest version by examining the file ./lib/viper/version.rb or by using the --version flag when running the editor executable.
You can also get the version from the help command (Ctrl-H, F1, or :help).


Do not change the version of the editor in a PR. That should be left up to the Viper maintainers.


### Semantic Versioning


Viper version numbers conform to the semantic version guidelines listed at: [Semantic Version 2.0.0](http://semver.org)
This spec states the version number should be of the form: 'major.minor.patchlevel'.
Major version increments indicate a (possibly) non-backward compatible code/API change.
The minor number increment indicates a new feature or improvement that remains backward compatible within the current major version.
The patch-level increment indicates a bugfix that remains backward compatible with the current feature release at the minor version level.



Before version 1.0.0, many new features were being added to Viper. Each round of these have been tagged with
0.feature_version.0 using git tag.
However, since Viper was in early pre-alpha state, some 0.x.0 were not backward compatible with other 0.x.0 versions. With the release of version 1.0.0,
all future releases will follow the correct semantic version model.


## Using Viper itself to edit its own source code.


You can use Viper to edit the source code of Viper. You can either do this safely or try to live dangerously!


### Safe Viper usage to edit Viper source code


Use another instance of the stable version of Viper in another location.


```
  $ git clone git@github.com:edhowland/viper.git
  $ cd viper
  $ ./bin/viper /path/to/viper/fork/root/___/some-file.rb
```


You can also use the -c option here to perform a Ruby syntax check upon exiting the editor.
To get a better experience, first cd to the forked viper git repoand put the path to the bin/viper from the cloned master/stable version in your PATH.
Then you can use the cov_report and cov commands tools to inspect the simplecov report.
The viper source root contains a single line .viperrc file that loads the coverage report from ./coverage/coverage.json which is needed first before running the cov commands.


### Living on the wild side


If you desire, you can use the ./bin/viper executable within your forked repo to edit the source codes. If you break anything, though, viper may not be able to be used to fix the problem.
I reccomend using liberal git commits before attempting this approach. Also, run rake in ./spec frequently to see if anything breaks. If you get into real trouble, use another editor like vim, emacs or nano to repair something. 
Another good approach is to create feature branch before even beginningto edit anything. You can use many experimental branches and delete them if things go awry.
I use the git flow extension to manage feature/release/hotfix branches. I suggest you look into this model as well.
However, do not use the X.Y.Z branch names to create release branches that get backed into master. This namespace is reserved for the Viper core maintainers. Instead, use a name that represents the feature add or bug fix you wish to submit in your PR. If it gets approved, it  might get its own new feature or hotfix release number. You will get credit on the commit message for the merge into master.
If you want to become a core maintainer, see below.


## Becoming a Viper Core Maintainer


### Or, how do I get commit rights on the main viper repo?


I am very willing to get as many extra helping hands with Viper as I can
get. So if you are willing to help, you will probably be on a fast track
to becoming a core commiter. The first thing is to enter a issue on the
GitHub issue tracker with some bug fix or feature request. Then, fork a
copy of viper to your own GitHub account. Use the issue to comment on 
the problem and proposed solution. Use the comment field to report on
your progress with implementing it or fixing the bug. Whhen you have a
good enough release, merge it into master and issue a pull request. I or
one of the other maintainers will review it and if approved, commit it
into either master or the current feature branch.  State in an issue
comment that you are willing to help and you will probably get commit
rights. No promises, though. :)


## The structure of the Viper project tree.


To get familiar with the layout of the source code, here is a simple guide.


Most of the code is in ./lib/*. The main place to look here is ./lib/buffer. The buffer is the main class where the text under edit resides. It implements a simple gap buffer.


### Viper Main Event Loop


The main editor loop is implemented in bin/viper. Afterprocessing 
any command line options, it starts Viper::Control.loop witha block. The block gets yields once each time through the loop


### Buffer Class


The Buffer class implements a simple gap buffer like those found in Emacs style editors. A gap buffer really is 2 buffers, one contains all the text before the current cursor
position and the other one contains all the remaining text after the cursor position.
When you move the cursor, a single charcter is either popped or shifted off the buffer in the direction of movement and then either unshifted or pushed on the other buffer.
When inserting a character, it is just pushed on to the left buffer. Deleting a character depends on whether you are using backspace or Del. Either the character is popped off the left buffer and discarded, or shifted or the right buffer and discarded.
The only wrinkle to this simple scheme is moving the cursor up or down to a previous line or following line.


#### Lines model in Buffer


Since the buffers just implement a list of characters, lines are really virtual abstractions. The definition of a line is all the characters from either the start of the file or just after the last newline and
upto and including the next newline, or the end of the file. The wrinkle starts with current cursor position. It exists on this virtual line.
Some part of the current line is contained on the end of the left buffer and part of the right buffer. When moving up one line, you would like to maintain the current positionon the
destination line as the line you just left. And conversely if moving down one line the same column. Obviously, if the next line is shorter than
the line you just left, you must advance to the minimum of those line lengths/column locations.


### The Buffer Ring


Viper can handle any number number of buffers. These can be FileBuffers or ScratchBuffers or internal buffers. The various buffers are stored in the buffer ring.
The buffer ring is just a Ruby Array. To move between buffers, use the .rotate method of Array. Use (-1) to move backwards through the ring.
The current buffer is always the head of this array. To kill a buffer, (remove it from the buffer ring), just shift it off the head of the ring array and discard it. Ctrl-T moves forward through the buffer ring. F2 reports the name and other information about this head of the ring's buffer.
The commands: n, p and k! move forward, backward and kill the head of the ring, respectfully.


## Mappings and Bindings



### Key Mappings

Each possible keystroke is mapped to a Ruby symbol. Normal letters and numbers are mapped to: key_a..key_z, key_A..key_Z and key_0..key_9. All punction keys, control keys, function keys and 
 special keys like left, right, up and down arrows are mapped to symbolic names like: :space, :backspace, :up, :fn_1, etc. See the file lib/mappings/key_mappings.rb for a complete list.


### Bindings

Most of these key symbols are further mapped to a Ruby Proc that does the work. This mapping is called a binding. For example, the symbol :key_A is bound to a Proc that inserts the letter 'A' into the current buffer. Other keys are bound
to other procs that might operate on the buffer, or, on the Viper session itself. E.g. the aforementioned Ctrl-T
which is mapped to the symbol :ctrl_t is bound to a proc that rotates the buffer ring. The symbol :fn_1 is mapped to the proc that returns the 
symbol :cmd_help. More on that in the next section: Command Bindings.
These bindings can be found in the file: ./lib/bindings/make_bindings.rb.

### Command Bindings


Some key combinations, which are called key chords, perform other actions. For example, Alt+d starts a sequence that can be followed by the keys: d, home, end, PgUp or PgDn. These perform actions to delete the current line,
delete to the front of theline, delete to the end of the line, delete to the top of the buffer and
delete to the bottom of the buffer, respectfully.


The chord: Alt+; starts a command session. This session uses the CommandBuffer class which operates a little like the GNU Readline library. Any string entered here is interpreted as a command to execute.
These commands are bound to other procs in the file ./lib/bindings/command_bindings.rb.


These commands can also be operated on by Viper outside of the main editor loop. For instance, the 'viper' executable checks for the existance of
~/.viperrc or ./.viperrc. These files are loaded and any commands found there are executed as if they entered in the CommandBuffer
after Alt+;.


## Snippets, File Associations and System tools.


### TODO.















