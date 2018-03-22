# TODO Notes

## Link to ~/src/vish/bin/vishc, vsr

## Missing functionality of SlicedBuffer

- Overwrite

```
sb = SlicedBuffer.new 'hello world'
sb[0..4] = 'goodbye'
sb.to_s
# => 'goodbye world'
```

## the args to compiled vim.vsc  script match  normal shell script

E.g $0 is command, $1, $2 are args to script. This is ok.

Need to get the file(s) to edit via getargs([1] ...

