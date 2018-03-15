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


