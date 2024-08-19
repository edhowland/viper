alias savable=ask2_save
function unsaved_buffers() {
   filter &(f) { is_dirty :f } :(filter &(b) { savable :b } :(buffers))
}
   for b in :(unsaved_buffers) {
   name=:(pathname :b)
   (prompt_yn "save :{name}?" && save_file :b && echo file :name saved) || echo :name will not be saved
}
   
