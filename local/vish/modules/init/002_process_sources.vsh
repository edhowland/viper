# process_source.vsh if a path to a file.vsh is in argv then source it
function process_source() {
   src=:(first :argv)
   test -z :src || with_dir :proj { source :src }
   cond { suppress  { type main } } {
      # now check if they just want the help for the script
      rv=:(rest :argv); fv=:(first :rv)
      cond { empty :argv ||  eq '--help'":{fv}"    } {
         help_fn_doc main
      } else {
         exec { main :(rest :argv) && exit  0} || exit 1

      }
   }
}


#   main :(rest :argv)