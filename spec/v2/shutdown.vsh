test -e /v/buf && return
unsaved=:(filter &(f) { is_dirty :f } :(buffers))
for i in :unsaved {
name=:(basename :i)
(prompt_yn "save :{name}?" && save_file :i ) || echo :name will not be saved
}

