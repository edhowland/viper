# The help command



### Synopsis of the help command

```
help <topic>
```

where '<topic>' is a string of the name of the topic you want to print
out the topic contents of.

#### Return value

If the topic is found, first it is 'cat' to stdout and then 'help'
will return 'true'. If no topic matches that string, then 'false' will be
returned after the message: "No help topic can be found for <topic>" is printed on stderr.


#### Keyword argument

Since help topics are to be found in the ':hpath' help path variable, this can be
overridden via a keyword argument:

```sh
hpath=/home/me/.config/vish/topics help other_topic
```



## Format of Help topics

Help topics are just Markdown files, like this one you are looking at.

The file nname, in this case 'help.md' is the same as the topic argument
with '.md' attached.

## Where Help topics can be found

As mentioned above,  help topics are merely Markdown files located in the help
path found in the ':hpath' variable. This  is a list of full pathnames
delimited by ':' colon characters.

### Location of most help topic Markdown files

Most of the help topics are contained in a packages '<package>.d/topics/ directory.

When a package is loaded with the 'load' command, and it contains help
topics, it will probably prepend its package dir/topics to the existing ':hpath'
variable. After the 'load' command completes, new topics will become avaiable
to the help subsystem.

Note: If a topic Markdown file has the  same name of some other topic file
previously found in ':hpath', the new topic will override the old topic.

 