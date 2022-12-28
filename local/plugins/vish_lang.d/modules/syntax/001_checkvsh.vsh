rem checkvsh fn checkvsh
function check_vish_syntax(object) { 
  capture { cat < :object | vsh_parse } { echo Syntax Error }
}
function checkvsh() {
   check_vish_syntax :_buf
}
