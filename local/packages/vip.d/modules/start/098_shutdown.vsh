alias savable=ask2_save
at_exit {
   echo running the 098 at_exit
function unsaved_buffers() {
   filter &(f) { is_dirty :f } :(filter &(b) { savable :b } :(buffers))
}
   cond { test -e /v/buf } { perr no buffers exist so exiting } else {
   for b in :(unsaved_buffers) {
   name=:(pathname :b)
   (prompt_yn "save :{name}?" && save_file :b && echo file :name saved) || echo :name will not be saved
}
   }
}
