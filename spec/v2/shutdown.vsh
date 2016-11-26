unsaved=:(filter &(f) { dirty :f } :(buffers))
for i in :unsaved { echo :i is unsaved }

