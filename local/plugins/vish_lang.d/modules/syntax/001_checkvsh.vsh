rem checkvsh fn checkvsh
function checkvsh() { 
  capture { cat < :_buf | vsh_parse } { echo Syntax Error }
}
