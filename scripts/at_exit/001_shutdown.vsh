test -e /v/buf && return
unsaved=:(filter &(f) { is_dirty :f } :(reject &(x) { echo :x | grep -q scratch } :(buffers)))
for i in :unsaved {
name=:(basename :i)
(prompt_yn "save :{name}?" && save_file :i && echo file :name saved) || echo :name will not be saved
}

