rem better_repl.vsh a better vish than old vish
source safe_eval.vsh
cmdlet is_nil '{ return (args[0].nil? ? true : false) }'
function rep1(pr) {
  res=:(getline :pr)
   is_nil :res && raise EOF
   test -z :res && return
  safe_eval ":{res}"
}
function vish_repl() {
   loop {
  capture {  rep1 :prompt } { break } { echo }
     }
   echo Exiting Vish
}
