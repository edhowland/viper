rem process_c.vsh handle the -c syntax check of .vsh files and exit
function process_c() {
  test -X /v/options/init/actual/c && exec {
    (cd :proj; for s in :argv { echo -n ":{s}: "; check_vish_syntax :s })
  exit 0
  }
}