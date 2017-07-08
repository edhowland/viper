# Command help for Viper editor

The command mode for Viper can be invoked via Alt Semicolon. commands can be entered with any arguments and executed via pressing Return.
After execution, you will be returned to the Viper editor.

## Special Keys in use in Command mode

- Left Arrow : Moves one character back on current line
- Right Arrow : Moves one character forwardon current line
- Up Arrow : Moves to end of previous line in Command history
- Down Arrow : Moves down to next line in command history if any
- Shift Home : Moves to beginning of current line
- Shift End : Moves to end of current line
- Control d : Exits command mode
- Control q : Exits Viper editor, asking to save any unsaved buffers


## Special commands

Following are some commands which may be of use in command mode

### help

```
help
help keys
help command
```

help starts the help browser either on the help start page or with anotherpage.

- help ; help help  : Starts help browser on main help start page
- help command : Starts help browser on this page: Command help
- help vish : Starts help browseron Vish command shell
- help viper : Starts help browser on Viper help page
- help keys : Starts help browser on Viper special keys enumeration help page
- help bind : Starts help browser on key binding help page

### echo



```
echo
echo hello world
echo -n text without a newline character
echo :version
echo :_buf
echo -n hello world | ins :_buf
```


Echo outputs  its arguments to standard out. Thish can be useful to investigate
variables, settings and other uses

#### _buf

The  :_buf variable is the internal pathname of the current buffer.
Note: If you want to see the filename the buffer referenced via :_buf, use the buffer command, followed by enter.

The last command referenced in the above code block: echo -n hello world | ins :_buf
inserts the string "hello world" in the current buffer at the current cursor position without a trailing newline character.

### cat

```
cat < :{_buf}/.pathname"
```

The cat command copies standard in to standard out.
In the above example, we can query the full pathname of the current buffer via redirection.
Note: This example uses string interpolation to reference the :_buf variable to complete
the internal pathnameof the .pathname variable.

### cd

```
cd
cd /home/user/src/rb_project1
cd :proj
cd -
```

The  cd command changes the current directory of the Viper editor processs to its argument.

#### The - argument

The '-' argument returns to theprevious directory. It is the same as 'cd :oldpwd'.


#### proj variable

The :proj variable is set at Viper load time to the current directory of the shell that invoked Viper.
The cd command with no arguments, returns to this location.


### save

```
save
```

The 'save' command saves the current buffer (referred bia :_buf)   to its full pathname on disk.



### The o command

```
o file.rb
```

The 'o pathname' command, a Vish function actually, opens a new buffer and loads the pathname
into it making it the current buffer.

### The prev and next commands

```
prev
next
```

The 'prev' and 'next' commands rotate the buffer list backward and forward, respectively.
The 'next' command is the same as pressing Control t in the Viper editor mode.
If the buffer list end has been reached, further next or prev command will rotate to the beginning or end of the buffer list.
The :_buf variable will be set accordingly.




