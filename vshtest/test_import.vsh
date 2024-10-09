mod test_import {
function test_import_empty_dir_does_not_fail() {
   mkdir /v/tmp/foo.dir
   mpath=/v/tmp import foo.dir
   assert_false :exit_status
}
function test_import_works_with_one_file() {
   mkdir /v/tmp/bar.dir
   echo "rem I am 001" > /v/tmp/bar.dir/001_rem.vsh
   mpath=/v/tmp import bar.dir
   
}
function test_import_works_with_many_files() {
   mkdir /v/tmp/baz.dir
   echo "rem I am 001" > /v/tmp/baz.dir/001_rem.vsh
   echo "blah=97" > /v/tmp/baz.dir/002_blah.vsh
   echo "realsp='foo bar'" > /v/tmp/baz.dir/003_rs.vsh
   mpath=/v/tmp import baz.dir
   assert_eq 97 :blah
}
function test_import_empty_with_on_import_works() {
   mkdir /v/tmp/import/foo.d
   echo "im1=100" > /v/tmp/import/foo.d/on_import.vsh
   mpath=/v/tmp/import import foo.d
   assert_eq  100 :im1
}
}
