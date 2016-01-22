# VIPER

## Visually Impaired Programmer's Editor in Ruby

### Version 0.9.4


Note: This version changes the snippet UI dramatically. Read below for information on how to load and create, store snippets.


## Abstract

This is simple editor in Ruby that works with screen readers, esp. like VoiceOver 
in Mac OS/X. 
Viper only attempts an audible interface. Sighted users of the programwill only see confusing giberish on the screen.


## System requirements


Viper has been tested with Ubuntu 14.04, Ruby 2.2 and the terminal type: xterm-256color.


## Installation


Clone this repository. Change to the viper directory.
Then run bundle.


## Usage:

```

./bin/viper file.rb

```

This executes the main editor loop. To exit, hit Ctrl-Q at ant time.

### Use the following control characters for some actions:

- Ctrl-S: Saves the current buffer.
- Ctrl-Q: Exits the main editor loop and asks to save the current buffer, if dirtyi
- Ctrl-H - Brings up Help text

## Command line options


```
./bin/viper --help
```


## Features:


Snippets - Ability to record and playback short snippets of commonly used texts.
Copy and Paste: Limited Shift+right, left arrows to select text and Ctrl-C, X and V to Coy, Cut and Paste.
Search and Reverse Search. (Ctrl-F. Ctrl-R).
Ctrl-G to continue searching in the last direction of the last search.
  Since the search enter area is another buffer, can use regular editor commands within it. E.g. Ctrl-V to paste in some 
  text to be search to be for.
Also, up and down arrows work like in Bash readline to recover the last thing you searched for.
Undo/Redo: Ctrl-Z and Ctrl-U will undo the last editor action, and replay them uf needed.

Ctrl-A: Selects the entire buffer.
Ctrl-Y - Yanks the current line into the clipboard.
Fn4: Sets/Unsets a mark. Cursor movements from there selects and highlights text.
The Meta key is Alt or Option depending on your keyboard layout.
Meta+D - Starts a Delete sequence:
+ 'd' - Deletes the current line.
+ Shift+Home - Deletes to the front of the current line.
+ Shift+End - Deletes to end of the current line.
+ Shift+PgUp - Deletes to the top of the buffer.
+ Shift+PgDn - Deletes to the bottom of the buffer.


Debug mode: For debugging the editor itself.
  Ctrl-D enters pry, where you can look around. Ctrl-D again to return to editor loop.


## Command Entry


Option/Alt+';' enters command mode where you can run some some editor functions.
These are very vim-like in form and syntax.
E.g.  w filename - writes the current buffer to filename. rew! re-reads the current file back
into the current buffer, overwriting any changes.
check - performs a Ruby syntax check on the current buffer.
lint - performs limited lint on current buffer. Ensures every line is indented with an even number of spaces.



###### Note: -c, --check-syntax performs the same function on editor exit

## Help


Meta help brings up a help buffer. You can
return to the previous buffer with either Ctrl-T or meta+n, meta+p to rotate through buffers.
k! will delete the current buffer without saving it first. This is
like Close Tab in a browser.


## Managing Snippets


Initially, there are no snippets loaded, but there is a default snippet collection. Viper ships with a number of snippet collections: ruby, spec and markdown.
These collections are stored in ./config/*.json. You can create new snippets and play them back using the command interface which is invoked with Option/Alt+; .
Snippet collections can be automatically associated with path/file/ext patterns. E.g. '.rb' can be associated with the ruby collection.
These associations can be either file part literals or regular expressions. E.g. /.+_spec.rb/ can be associated with the spec collection.
The most specific association wins in any constest between loaded associations. For example, in the above association, if it was loaded along with the ruby association, myfile_spec.rb would be associated with the spec collection, not the ruby collection.
But any other file.rb would still be associated with ruby.



Here is an example session with creating a snippet, saving it and using it in a file.



```
load markdown markdown
assocx .md markdown
# now create a new snippet: the h6 heading
new
# enter: \n###### ^.\n
snip h6 markdown
dump markdown markdown
# Ctrl-T to return to previous buffer with Markdown content
h6TAB
# snippet h6 is played back and cursor is positioned at start of typing
```


In the above session, we loaded the ./config/markdown.json and loaded into the markdown collection.
Then we associated it with the '.md' file extension. Next, we created a new scratch buffer with the :new command.
After creating our snippet, we saved it with the 'h6' abbreviation name into the markdown collection with the :snip command.
Next, we saved our current markdown collection back to the ./config/markdown.json file.
Lastly, we returned to our previous file buffer and invoked the snippet with the h6+TAB combination.

That's all there is to it!


### Editing an existing snippet:


Use the :sedit command to load an existing snippet into a buffer to edit it. Use the :snip when done editing it to return it to the collection. You can return to your previous buffer
to test it out. When satisfied, remember to dump it back into the .json file.




Here is a sample editing session:



```
new
sedit h6 markdown
# Now edit the snippet's contents.
snip h6 markdown
k!
# You are now in your previous buffer. Try out the new h6 snippet with: 
h6TAB
# It works! Now save it
dump markdown markdown
```


### Tab points

Within the contents of the snippet, you can set Tab points (stops) with the '^.' combination. You can set as many of these as you need. For example, ifelif might have 5 of these for the if condition, the 
if stanza, the elsif condition, the elsif stanza and the else stanza.
When a snippet is first invoked, the buffer will automatically advance to the first tab point, if any.


Note: Remember to make sure to keeping hittingthe tab key to advance to any subsequent tab points. Tab will first erase the '^.' in the buffer so you can start typing from the tab point.
If you forget to clear all the tab points, you might get a syntax error in your code.
You can find any left over tab points by Ctrl-F and entering ^.Return




### Automating the load and association of Snippet Collections

Viper will check for a ~/.viperrc file. If it exists, it will attempt to execute commands contained within, one per line.
You can also create a .viperrc file in any directory. It will be loaded last. You should only put any commands there that do not require a buffer to operate. Also, any quiting commands with not operate. Also, you will not hear any output in audio, so do not put list, reporting commands there.


