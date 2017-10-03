# Macros

A macro in Viper is simply a list of keystrokes applied to the current buffer.
The key stroke would exhibit the same behaviour as if it had been entered via the keyboard.

Macros can be invoked either via a bound key, like a control or alt key or function key.
They can also be invoked by name via the Alt comma key which looks at the last word entered.

Consider the following example:

Assume a macro named 'def' was previously created.
In any buffer, enter the following chars:

d e f alt comma

This will get expanded into the following text:

```
def method
  #
end
```

After this expansion, the cursor will be placed on the 'm' in the word 'method'.
The user can begin editing the method name, parameters and body.

## Creating macros

Macros can be created either interactively or via the command interface, via invoking Alt semicolon.
Interactively, you are prompted to start recording keystrokes, then stop recording and then use
the command interface and save the  macro under a new name.

Explicitly, you can create a new macro  on the command interface and bind it
a single keystroke.




### Create a macro interactively

Position the cursor where you want to create your macro., Or open a new scratch buffer
via enter Control n.

Then press F 6. You will be prompted to enter keystrokes
until you are finished with the expansion of your macro. Finally, press F 6 again.


You will be prompted  to enter Alt semicolon and the command save_macro with the 
name of the macro.

```
save_macro exp
```


This macro can then be invoked at any future time via enter 'exp' followed by Alt comma.

#### Permanently saving macros 

Once you have created one or more macros, you can save them for future Viper sessions.
Enter Alt semicolon to start a command entry. Type
'dump_macros.


## Setting cursor positions

You can set bookmarks in your macro and then use the 
bookmark movement keys to position the initial cursor position. See [Bookmarks](bookmarks)

