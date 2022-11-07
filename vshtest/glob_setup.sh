# glob_setup.sh: creates test dir tree structure to test Bash globbing
# Usage: bash glob_setup.sh
# It can be removed by running bash glob_teardown.sh
source ./glob_config.sh



mkdir -p $TEST_GLOBROOT
cd $TEST_GLOBROOT
# Globs should not find this file
touch nofind.me
touch aa3
mkdir -p aa1/za1 aa2/za2 ba1 ba2
touch aa1/foo.txt aa1/bar.txt aa1/file.xxt
touch aa2/baz.txt aa2/ aa2/spam.txt aa2/none.txx
touch ba1/fly.txt ba1/run.txt
touch ba2/

