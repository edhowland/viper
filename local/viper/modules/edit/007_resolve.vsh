rem resolve.vsh attempts to understand the type of the buffer
mkdir /v/known_extensions/default
cmdlet extname '{ out.puts File.extname(args[0])[1..] }'
function resolve_ext(name) {
  ext=:(extname :(pathname :name))
  run_ext_fn :ext
}
function set_ext_fn(ext, fn) {
  store :fn "/v/known_extensions/:{ext}/settings.fn"
}
rem setup editor defaults for language settings
set_ext_fn default &() { checker=check_default  autoindent=false indent=2; global checker autoindent indent }
function run_ext_fn(ext) {
  test -z :ext && ext=default
  cond { test -d "/v/known_extensions/:{ext}" } {
    cond { test -x "/v/known_extensions/:{ext}/settings.fn" } { exec "/v/known_extensions/:{ext}/settings.fn" } else { perr could not find a settings.fn for extension :ext }
  } else { exec "/v/known_extensions/default/settings.fn" }
}
