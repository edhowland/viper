# Bookmarks

Bookmarks in Viper are stored positions in your current buffer. They can be used
to move around the document or select text for cut or copying. Bookmarks (also called marks) 
can be used in macros to position the cursor after playing back a macro.


## Setting a bookmark

Bookmarks can be set several ways. Below are 4 ways to set a bookmark:

- Press F4 :  Sets a bookmark at the current position.
- F5 : Sets a bookmark called T at the current position. Used for macro recording.
- Meta m : Prompts for a named bookmark, and sets it at current position.
- Enter Vish command: trait_set :_buf m : sets a mark called "m" at current position.


## Cut and Copy using Bookmarks

To select a region of text to cut and or copy, use one of the 4 methods above. Then move to 
the ending position you want to select. Then press Control X to cut
and Control c to copy. The selected text
will be stored in the current clipboard.

The contents of the clipboard can be pasted somewhere else in the current 
buffer or some other buffer.

## Moving around using Bookmarks

Once you have set one or more bookmarks,
you can move between them via the Meta f to move forward and Meta r 
to move backward.

This can be used in macro recording. For instance,
while recording a macro, position the cursor where you want
to have the macro jump to after the macro has been expanded. Then press F5 to 
set the t mark. When the entire macro has been recorded, but before
you press F6 to stop recording, use Meta r to move back to  the first bookmark set
in the macro.



