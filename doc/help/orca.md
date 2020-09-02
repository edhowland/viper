# Orca Screenreader help

Using Viper with the Orca screenreader in the Gnome terminal in Linux distributions
requires some adjustments.

## Function keys

Viper uses several function keys; mainly for informational purposes. In both Gnome terminal and using
the Orca screenreader, these may be mapped to other actions.

You can get the same behaviour by pressing Alt plus 1through6

## Cursor keys and movement keys.

Orca seems to suppress output on the terminal whenever cursor keys or backspace keys are pressed.
Although the action is performed, you may not get any audible feedback. 

You can alias keys to existing key actions via the alias_key function in the command mode.
Viper provides a Vish script to set these for common actions in the editor.
Do the following either in command mode or by placing the line in your
~/.vishrc file:

```
source ":{vhome}/etc/keymaps/orca_alias.vsh"
```

This adds aliases for keys like Alt plus n for backspace and Shift plus Alt plus J for Page Down to go to the bottom of the buffer.

### Orca alias keys

- Alt y : left arrow
- Alt u : Down arrow
- Alt i : Up arrow
- Alt o : Right arrow
- Alt n : Backspace
- Shift Alt N : Forward delete
- Alt b : Back Tab
- Shift Alt H : Home or Move to front of line
- Shift Alt J : Page Down or move to bottom of buffer
- Shift Alt K : Page Up or move to top of buffer
- Shift Alt L : End or move to end of line

