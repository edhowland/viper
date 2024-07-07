rem create help alias which are regular aliases with h_ prefix
function help_alias(cmd, xpand) {
   mkdir /v/help/aliases
   echo ":{xpand}" > "/v/help/aliases/:{cmd}"
}
function hget(cmd) {
   loc="/v/help/aliases/:{cmd}"
   test -f :loc && exec { cat :loc; return true }
   return false
   }
   help_alias topic topics
   help_alias debug "echo help alias is working"
   
  