rem resolve.vsh attempts to understand the type of the buffer
mkdir /v/known_extensions
cmdlet extname '{ out.puts File.extname(args[0])[1..] }'
function resolve_ext(name) {
  ext=:(extname :(pathname :name))
test -X "/v/known_extensions/:{ext}" || exec { checker=check_default; global checker; return }
  test -z :ext || exec { checker="check:{ext}"; global checker }
}