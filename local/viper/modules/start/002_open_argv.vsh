rem process_files.vsh function to start all and open all files in argv
function open_argv() {
  for f in :(reverse :argv) { fopen :f }
}