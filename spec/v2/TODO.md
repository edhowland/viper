# TODO

Outstanding bugs:

Bug in handle_tab, occurs when recorded one macro, trying to record 2nd one and tab
Make com, when raised in commander, be able to return to previous mode
Add (somehow) autoindent be used in ctrl_m (Enter/Return)
  > gets current indent_level before performing ins of newline.
  > then inserts that number of spaces.
  > But does not do this if autoindent is false
Implement some means of toggling autoindent off/on when rotating thrubuffers 
  > based on file extension. /mode/.../.rb/activate is script or block
Make Vsh able to set variables in global environment, w/o requireing global expression

