# Keys - How Viper processes keystrokes

## Abstract

Viper needs to know which key was pressed in order to run a command associated with that key.
For instance, if the right arrow key is pressed, Viper needs to moe the cursor 
one character to the right in the buffer.  If a printable char was pressed,
then it needs to be inserted in the buffer at the cursor point.

## The Remedy gem


Viper uses Remedy gem:

- [https://github.com/acook/remedy](https://github.com/acook/remedy)

This gem, in addition to making NCurses like terminal things possible in a Ruby
environment, also processes raw keyboard input.

### Why raw keyboard is needed

Terminals vary in the  way they handle keyboard keys not part of the approximately
128 ASCII possible character codes.

- 96 Printable characters, including the shifted characters.
- 32 Control characters

In addition to the above,there is often the following characters:

- The Alt (sometimes called the Meta) key.
- The Function keys F1 - F12. (Viper uses only F1 - F6)
- The arrow keys
- The Six-Pack keys (On some keyboards: above the "inverted T" arrow keypad.
  * PgUp, PgDn
  * Home, End
  * Ins, (forward) Del

### Note re: scan codes

Viper does not rely on very raw scan codes to determine what key was pressed.
Viper uses the Remedy raw keyboard input functions. See below.

## The two Remedy types of of keyboard input

- Canonical input.: Remedy tries to interpret the key that was pressed and  and returns a :symbol
- Raw. The ASCII char or the ASCII escape sequence is returned.

Since Viper has to accommodate input from a number of  possible sources:

- MAcOs
- Linux

it cannot use the canonical form. It must, therefore, map the escape sequence
to its own form of canonical symbol names.

## Experimenting with the raw character input

You can use the Vish REPL and play with what Viper does with its raw input.

Open viper and then use the following key sequence to first goto command mode,
then enter the Vish REPL.

1 Enter Alt+';'You will hear that you are in Command
2. Type 'vish' and press Enter.

```
# The raw command followed by a variable identifier, will wait for a key to be entered
# Then the value of that key will  be placed in  the variable.
vish> raw k
# Now print it out with the ':' dereference sigil
vish> echo :k
# But, for non-printable keys do the following stuff:
raw k
echo -x :k
# The ASCII codes of the command will be printed
# Try other keys
vish> raw j
vish> echo :j
^D
```

Hitting Ctrl-D will return to the main Viper editor mode

Note: Remember to use the ':' sigil to dereference the variable


## The 'raw' command does get raw input, but there is no way to gets its
numerical escape sequence.

A better way to see what is happening.

Invoke the 'pry' mode:

` Enter Alt+';' to enter Command
- Type 'pry' and press Enter

Try the following stuff:

```ruby
>> r=Raw.new
k = r.getch

# Waits for some key to  be pressed
# Say we press F1

>> k.chars.map(&:ord)
=> [27, 79, 80]
```



## Using raw and xfkey to determine name of key

The next step is to map the raw character or the longer escape sequence
to a canonical key name.

```
# Type this line and then press the F1 key
vish >rawspace-space|spacexfkey
fn_1vish >
```

The output of xfkey does not have a newline so immediate the 'vish>' prompt
trails  the fn_1 above.

## Mapping a key to an action with mode blocks

Once a keystroke has a canonical name like 'key_F', it needs to be mapped to an action.
In the above case, Viper might want to insert the letter 'F' into the current
buffer.
This is accomplished by locating a Vish code block and then executing it with
the 'exec' keyword.

### Why is there a code block and not just some builtin function?

In some scenarios, Viper might want to  perform more than one action in order
to accomplish some task.  E.g. to delete some some stuff, we might want to:

1. Mark the current cursor position
2. Move the cursor to the next position
3.  Delete back to the previous mark.

## Where Viper stores the blocks to be executed

Viper has many modes. (See Modes.md)
The current mode in force is stored in the variable: '_mode'.
You can always get the current mode by de-dereferencing it with the ':' sigil.

```
echo :_mode
viper
```





The modes are stored in the virtual path: /v/modes

```

vish >cdspace/bvdelete vdelete bv/modes
vish >ls
command
delete
help
init
ins_at
macros
mark
prompt
search
undo
viper
```



Let's examine a few pathnames in a given block: /v/modes/undo:

```
# ...
ctrl_s
ctrl_v
ctrl_w
ctrl_x
ctrl_y
fake_backspace
fake_cut
fake_delete
fn_4
ins_at
key_0
key_1
key_2
key_3
key_4
key_5
key_6
key_7
key_8
key_9# ...```




You can always examine a virtual object with the 'stat' command.



```

vish >cdspace/v/modes/viper
vish >statspacekey_F
stat
key_F
virtual? true
directory? false
Lambda: &() { ins :_buf :ky }
```


Here you can that this virtual object is a stored lambda which uses the 'ins'
command to store the current :ky into the current :_buf, or buffer.


For instance, we can perform the action explicitly:

```

vish >ins :_buf 'f'
```

After the above, the letter 'F' will be stored at the current position in the current buffer.




## Movement keys and other action keys are stored as code blocks

```

vish >cdspace/v/modes/viper
vish >statspacemove_right
stat
move_right
virtual? true
directory? false
Block: { capture { fwd :_buf } { bell } { at :_buf } }
```




The above takes a bit more explanation.
The simple case would to just call the 'fwd' command on the current buffer: :_buf.
However, what if you are at the end of the buffer? This requires capturing that end of buffer exception.
This is done with the 'capture' triple. This consists of 3 blocks:

1. The try block to perform the requested action.
2. The action to accomplish if there is an exception. In this case, rings the bell.
3. The action to perform if the try block is performed without raising an exception.

The latter point is to report the character at the current cursor location.




## Getting help with a certain key with the F3 function

If you press F3, it will prompt you for the next key to be pressed, and then report
its function. This only currently works for movement and action keys.
You can assume that printable characters will just be be inserted at the current cursor.

Let's examine what the F3 key does. Its canonical name is 'fn_3'

```
space/v/modes/viper/fn_3
stat
/v/modes/viper/fn_3
virtual? true
directory? false
Block: { key_prompt }
```

But, what exactly is 'key_prompt? It is a function that lives in scripts/003_help.vsh:

```
function key_prompt() {
  perr -n Enter key to hear its action
  key=:(raw - | xfkey)
  help_key :key
}
```

Note: In Vish mode or at the command prompt, using the help_key function
and the canonical key name will print the help for that function in the current mode.
This is another way to get help for  a key.

## Putting it all together


Looking at the above function: key_prompt, we can get a feel  for what actually happens when 
a key is actually pressed in the Viper editor.

Let's make a function  that waits for a key to  be be pressed, and then performs its function.

```

function run_key() {
  perr Press a key
  k=:(raw - | xfkey)
  exec /v/modes/:{_mode}/:{k}
}




Save this to a file and then in Viper, launch command mode with meta semicolon.

```
source run_key.vsh
```

Then re-launch command mode and type the function name.

```
commandrun_key
Press a key
j
```

## Summary

In Viper, a keypress invokes some action that gets executed by the Vish
command language. Along the way, the keypress goes through some transformations.

1. The raw key is captured and passed through the pipeline to ...
2. The 'xfkey' internal function is called which maps the raw key ordinal values to some canonical string which is the key's name.
3. This string is used as the virtual pathname in the current mode's key actions in /v/modes/:{_mode}
4. These virtual objects in /v/modes/:{_mode} are either Vish code blocks or a reference to the printable key insert lambda.

The run_key function we coded above gives a flavor of the actions steps
we have outlined here.
