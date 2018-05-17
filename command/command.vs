# command.vs - functions to implement command mode in Viper
#
# The command repl, w/o the l(oop)
defn com() {
  prints('command ')
  %read | %cparse | %_emit | %_call | %print
}

defn o(fn) {
  "opening %{:fn}"
}
# quitting
defn q!() {
  "exiting without saving"
}
# saving
defn w() {
  "saving file"
}
defn wq() {
  "save and quit"
}
defn n() {
  "next file"
}
defn wn() {
  "save and open next file"
}
defn rew!() {
  "re-wind and reopen first file"
}

