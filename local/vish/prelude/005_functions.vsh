rem Common Vish functions
function dircount(dir) {
  cond { test -e :dir } { echo 0 } else { (cd :dir; echo -n *) | wc -w }
}
function second(a, b) {
  echo :b
}
function third(a, b, c) {
   echo :c
}
function fourth(a, b, c, d) { echo :d }
function fifth(a, b, c, d, e) { echo :e }
rem find_first recurses over all remaining in list or using :ifs delimiter
function find_first(qterm, elem) {
  cond { test -z :elem } { return false } {
    eq :qterm :elem } { echo :elem; return true } else {
    find_first :qterm :_ }
}
rem module_path returns the first found matching module in :mpath else false
function module_path(mod) {
  ifs=':' for p in :mpath {
    test -d ":{p}/:{mod}" && exec { echo ":{p}/:{mod}"; return true }
  }
  false
}
rem hunt is dummy to eventually rid us of the hunt command
function hunt() {
  nop
}
function check_default() {
  perr No syntax check for this file type
  return false
}
function package_path(pkg) {
  ifs=':' for p in :lpath {
    test -X ":{p}/:{pkg}_pkg.vsh" && exec { echo ":{p}/:{pkg}_pkg.vsh"; return true }
  }
  false
}
mkdir /v/macros
mkdir /v/known_extensions/default
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
function with_dir(dir, exe) {
   opwd=:pwd
   cd :dir
   exec :exe
   cd :opwd
}
function cddr(a, b) {
   echo :_
}
function cdddr(a, b, c) {
   echo :_
}
function cadddr() {
   first :(cdddr :_)
}
function _help(topic) {
   echo "The help subsystem has not yet been loaded. Please type either 'load vish_help' or 'load viper_help' which loads both Vish and Viper help packages"
   return false
}
function man(command) {
   echo "The help subsystem has not yet been loaded. Please type either 'load vish_help' or 'load viper_help' which loads both Vish and Viper help packages"
   echo "Running the command 'load vish_help' will also load the sections of the Vish manual"
   echo "And running the command 'load viper_help' will load the sections of the  manual specific to Viper only commands"
   return false
}
function head() {
   cond { is_tty } { sh head :_ } else { sh - head :_ }
}
function tail() {
   cond { is_tty } { sh tail :_ } else { sh - tail :_ }
}
function grep() {
   cond { is_tty } { sh grep :_ } else { sh - grep :_ }
}


