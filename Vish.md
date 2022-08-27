# Vish

## Abstract

Vish is the command language of the Viper code and text editor.
Most features of the editor are implemented as Vish commands. For instance,
a keypress is bound to an execution block. When the key is pressed,
it is looked up in the current mode and then the code block is exec -ed.

## Vish modes in the standard Viper insert mode.

When Viper is invoked, it starts up in insert mode. In this mode, there are
2 ways to interact with the Vish language.

1. Command mode
2. Vish REPL or the Read-Eval-Print-Loop interactive mode.

## Vish is similar to Unix shells you may have used recently.

The Vish  language is of the form of 




## Evaluating Vish strings as code

Caveat: This is obviously a security problem. Never 'eva' user input.

### The 'eval' command

```
eval "echo I am being evaluated" | cat
I am being evaluated
```
