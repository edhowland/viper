# Bind keys in various modes

The bind function can be used to map a particular key name, like ctrl_b, to some action.
You must state the _mode variable befor calling the bind function.
The bind function takes 3 arguments:

- The canonical name of the key. E.g. ctrl_a, key_F, meta_j or fn_3 etc.
- The control action which can be either an anonomous function or a block.
- The View action which can be either an anonomous function or a block.

See below for explanations of modes, key names, control actions and view actions.

## Modes

- viper : Main editor keys
- search : Keys in used in search mode
- command : Keys used in command shell
- help : Keys used in help document browser


## Key names

When keys are pressed, they are converted into canonical key name strings. The general syntax is key type underscore key value.
E.g Control A would be ctrl_a. And Function 9 would be fn_9.
See below for canonical key type names, along with some examples:


- key_ : Normal printable ASCII characters. E.g. key_a, key_B, key_period, key_lbracket
- ctrl_ : Control. E.g. ctrl_a, ctrl_space, etc.
- meta_ : Alt keys. E.g. meta_d, meta_comma
- fn_ : Function keys. E.g. fn_1, fn_2, fn_3 ... fn_12
- move_ : Movement keys. E.g. move_left, move_up, move_shift_home, move_shift_pgdn

## Control actions

The first argument to the bind function is either a block or a lambda function.
What happens within this block or lambda is the desired action when the key
is pressed. For instance, a movement key might be as follows:

```
{ up :_buf }
```


## View actions

The View action is the second argument to the bind function. It  is either a block
or a lambda function. The action is what is desired
to speak once the Control action has been completed.

For instance, here is the View action for the move_up key:

```
{ line :_buf }
```

### A complete example

```
_mode=viper bind move_up { capture { up :_buf; line :_buf } { bell } } { cat }
```

In the above example, we first set the _mode variable to viper. Then, we apply the 
up command to the :_buf variable which is the current variable. We do all this in a capture
block since it might raise an error if we exceed the top of the buffer.

Finally,we  pass the entire output throug to the View block. In this
block, we just have to use the cat command to pass the output to the standard output
which is then spoken aloud via the screen reader.

### Note regarding the interaction between the Control and View blocks.

The standard output of the Control block is piped through to the View block.
This is useful if you delete a string in the buffer and you want to speak aloud the contents of the string.

## Informational only blocks

In some cases, you may want a key to just speak aloud some information, without 
modifying the intrnal state of the Viper editor or its buffers.
In this case, use the 'nop' command to perform the
null operation.

Here is an example from my own ~/.vishrc

```
alias date='sh date'
_mode=viper bind ctrl_b { nop } { echo -n The current date and time is; date }
```

## Examing the binding of existing keys.

Existing keys that are bound to Control and View blocks can be examined via the 'bound' fnction. In the following example
we first set the _mode variable and then ask for bound and canonical key name.
The results are send to standard output  in a form that can be used 
to bind the real key.

From my own control b example again:

```
_mode=viper bound ctrl_b
_mode=viper bind ctrl_b { nop } { echo The current date time is;date }
```

### Examing a bound key in a text buffer

You may want to edit the current Control or View block of an existing bound key. 
Here is a technique you can use. Enter command mode and enter the following:

```
scratch; _mode=viper bound ctrl_b > :_buf
```

You will be placed in a new scratch buffer with the contents of the bound function. You can move aound and edit to your liking.
Now 
