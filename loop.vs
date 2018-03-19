# Main loop
defn vim(buf) {
%buf.L
ch='x'
loop {
  run(:buf)
}
}

