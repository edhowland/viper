# Piece Table data structure

## Abstract

A piece table is a string/file manipulation data structure that might offer some offers to gap buffers and ropes.

It provides:

- Unlimited Undo/Redo
- A copy of the original file buffer unchanged and read only
- Only insertions and deletions are recorded in the append table.

Additionally, some meta data might be be efficiently stored.

- Marks for cut/copy and tab points and bookmarks

## Implementation

There are 2 buffers.

1. A R/O buffer containing the original file from disk
2. The append file - Append only. Never deleted.

The append table only contains the spans of text that are deleted or inserted.

?? And marked???

The third data structure is a table structure containing the actions performed
in chronological order from first to current.

Note, both the append buffer and the piece table can be stored on disk (for backup and restore)

Notes:

this acts a lot like the way git stores its commits. Each commit is a list of diffs 
from the previous contents (for a single file)
There is am implied link back to the previous contents/commit.

### Writing the modified buffer to disk:

Let's say we only deleted and inserted some random lines in our buffer.

- delete 2
- insert 2
- delete 5
insert 9

The table can be mapped over the original buffer.

Each row in the table contains:

1. Offset
2 Length
3 Delete/insert
4. Pointer to append buffer of modified text
## The Piece Chain

Combining the 3 data structures O, A, PT
into a piece chain is one way to copy the data to file or a copy/cut clipboard. It looks like a tree, but may be more like a genearal DAG.



: repeat
Start at beggining of O
Read O until first offset
If delete, skip length chars.
If insert, read length chars
Continue to above: :repeat


