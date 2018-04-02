# commander.vs - commander(c, b, q)
defn commands() {
  defn w(b, q) { prints('save file') }

  binding()
}
defn commander(c, b, q) {
  co=sym(:c)
  x=commands()
  fn=:x[:co]
  undefined?(:fn) && { error('command not found'); return '' }
  %fn(:b, :q)
}
