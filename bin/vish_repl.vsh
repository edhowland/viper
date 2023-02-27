rem vish_repl.vsh This becomes the main loop for the ivsh command
load repl
cmdlet getline '{ pmt=(args.length.zero? ? locals[:prompt] : args[0]);  res=safe_get_line(prompt=pmt); out.puts res }'
echo 'nop' | vsh_parse __nop_blk
echo 'break' | vsh_parse __break_blk
function read_parse() {
  res=:(getline)
   test -z :res && return :__nop_blk
   eq ":{res}" ctrl_d && return :__break_blk
   echo ":{res}" | capture { vsh_parse  _blk } { perr :last_exception; return :__nop_blk } { return :_blk }
   echo 'perr Syntax Error 2' | vsh_parse __syntax_error; return :__syntax_error
}
alias vish_repl='loop { read_parse :prompt; exec :exit_status }'

