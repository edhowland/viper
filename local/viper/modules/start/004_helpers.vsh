rem helpers.vsh
cmdlet getline '{ pmt=(args.length.zero?? locals[:prompt] : args[0]);  res=get_line(prompt=pmt); out.puts res }'
function rep1(pr) {
  res=:(getline :pr)
  eval ":{res}"
}
rem run_repl. Starts up the REPL within the vish function
cmdlet run_repl '{ vm=globals[:__vm]; repl(vm: vm) }'
function vish() {
  run_repl
  echo exitting Vish
}
