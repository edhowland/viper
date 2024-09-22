# process_source.vsh if a path to a file.vsh is in argv then source it
function process_source() {
   src=:(first :argv)
   test -z :src || with_dir :proj { source :src }
   suppress  { type main } && main :(rest :argv)
}
