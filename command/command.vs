# command.vs - fn for command - dispatches to Vish
defn com() {
  prints('command ')
  %read | %cparse | %_emit | %_call | %print
}
