rem resolve.vsh attempts to understand the type of the buffer
cmdlet extname '{ out.puts File.extname(args[0])[1..] }'
function resolve_ext(name) {
  ext=:(extname :(pathname :name))
  run_ext_fn :ext
}
