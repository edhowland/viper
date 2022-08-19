# Searching in Viper

Viper can search either forward or backward in the current buffer. A search term
can be searched again in the current direction.

## Search activation keys

- ctrl_f: Prompt for a search term and search in the forward direction in the current buffer.
- ctrl_r: Prompts for a search term and begins searching in the current buffer but in reverse from the cursor.
- ctrl_g: Repeat the last search (in the last search direction)

### Search history

Previous entered search terms are in the search history buffer.
You can use the up and down arrows to move between them.
You can use the left and right arrows to move on the currently selected search term.
You can also use backspace or forward delete to edit the characters in the currently
selected search term. Pressing Enter will perform the search and move the cursor
to the start of the found search match. Pressing ctrl_g will move to the next match.

## Searching uses Regular Expressions for matching.

This may be a little unusual, but most search queries will work
just fine when used as a regex. There are some things to avoid:

- '.' Use '\.'
- '[', '']', '{', '}', '(' or ')' Use a backslash to escape these characters.
- '*', '+' or '?'. Use '\*', '\+' or '\?'.

Ofcourse, you can use these normal operators in their regular expression context.

## There is no case-insensitive search.

Please remember to use a character class to perform this kind of search. Or, when searching
for something that you might not know is capitalized or not, begin with the second letter
of the term.

@E.g. To search for an unknown case of the word: "Word" or "word":

```
[Ww]ord
```