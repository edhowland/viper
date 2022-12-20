at_exit {
test -e /v/buf || exec { 
unsaved=:(filter &(f) { is_dirty :f } :(filter &(x) { ask2_save :x } :(buffers)))
for i in :unsaved {
name=:(pathname :i)
(prompt_yn "save :{name}?" && save_file :i && echo file :name saved) || echo :name will not be saved
}
  }
}


