# commander.vs - commander(c, b, q)
defn commands() {
  defn w(b, q) {
  contents(:b) | fwrite(:file_name)
   prints("save file %{:file_name}")
}
  defn q!(b, q) {
    exit
  }
  defn wq(b, q) { w(:b, :q); q!(:b, :q) }

  defn rew(b, q) { rewind(:b) }
  binding()
}
defn commander(c, b, q) {
  co=sym(:c)
  x=commands()
  fn=:x[:co]
  undefined?(:fn) && { error('command not found'); return '' }
  %fn(:b, :q)
}
