# Main loop
defn vim(buf) {
%buf.s | prints()
ch='x'
loop {
  run(:buf)
}
}

