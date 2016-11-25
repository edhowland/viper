# TODO

Outstanding bugs:

add delete mode to meta mode. meta_d will raise deleter signal
Fix deleting of marked contents when either backspace or del_fwd keys pressed
Make com, when raised in commander, be able to return to previous
Add sh call to external shell to run commands
Add check fn to run current buffer piped into 'sh ruby -c'
Add (somehow) autoindent be used in ctrl_m (Enter/Return)
  > gets current indent_level before performing ins of newline.
  > then inserts that number of spaces.
  > But does not do this if autoindent is false
Implement some means of toggling autoindent off/on when rotating thrubuffers 
  > based on file extension. /mode/.../.rb/activate is script or block
Make Vsh able to set variables in global environment, w/o requireing global expression
Add exit from editor in new file: shutdown.vsh.
  > Checks dirty flag on all buffers, offering to save any that are
  > Make a Y/N prompter method thats returns true/false in exit_status

