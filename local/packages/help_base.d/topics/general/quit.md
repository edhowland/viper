# Quitting, leaving or exiting Vish or Viper

## Abstract

The first thing most users want to know about any system and especially
editors is "How to I quit?"
This help topic attempts to address this concern.

## Quitting out of the Viper editor

There are various ways to quit out of Viper:

1. Press Control + Q when editing any buffer
2. Invoke Command mode with Alt plus semicolon, then type exit

### The Quit key command with Control plus Q

When editing any buffer, pressing Control plus Q will quit out of Viper.
If any buffers have not been saved, the user is asked to save them.

- Press y to save
- Press n to leave with unsaved buffer contents not saved


After all the buffers have been saved or not saved according to the user's
choice, Viper exits and returns to the invoking shell.


Note: Pressing Control plus s will save a buffer. Also pressing Control plus t
will rotate through all currently open buffers allowing you to save them
after a review.

## Entering 'exit' in the REPL from within Viper

Entering Alt plus semicolon will drop you into Command mode.
If you enter 'exit' and press Return, then Viper will exit without saving
any unsaved buffers and not even alert you to that fact. So, use with caution.



## Pressing Control plus d in the Viper REPL

If you are in the REPL within Viper, pressing Control plus d will exit
the REPL and return you back to the current buffer you were editing.

## Quitting in other contexts like the ivsh REPL or in Vish scripts

If you are in the 'ivsh' program and you press Control plus d, it will exit and
return you to the invoking shell.

You can also enter 'exit' and press Return to do the same thing.

### Using exit in Vish scripts

The call to 'exit' somewhere in a Vish script or any file sourced from that
script will immediately exit the script without evening returning from any
function or nested function calls.

Note: You can enter a number after the exit command and this will become
the exit code of the script. If no number is entered, then the exit code is 0
indicating a normal exit.

## Related topics

```sh
help exit   ; rem Synopsis and description of the exit command
```
