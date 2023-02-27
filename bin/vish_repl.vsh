rem vish_repl.vsh This becomes the main loop for the ivsh command
cmdlet is_nil '{ return (args[0].nil? ? true : false) }'
echo 'echo will just run nop;nop' | vsh_parse __nop_blk
echo 'echo will do a break;break' | vsh_parse __break_blk
function read_parse(pr) {
  res=:(getline :pr)
   is_nil :res && return :__break_blk
   test -z :res && return :__nop_blk
   echo ":{res}" | capture { vsh_parse  _blk } { perr :last_exception; return :__nop_blk } { return :_blk }
   echo 'perr Syntax Error 2' | vsh_parse __syntax_error; return :__syntax_error
}
alias vish_repl='loop { read_parse :prompt; exec :exit_status }'
load repl


