# Bind keys in various modes

The bind function can be used to map a particular key name, like ctrl_b, to some action.
You must state the _mode variable befor calling the bind function.
The bind function takes 2 arguments:

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

## View actions

