# glob_teardown.sh : cleans up test physical filesystem
# Usage: bash glob_teardown.sh
# Meant to be run after: bash glob_setup.sh  # But can be run idempotently
source ./glob_config.sh

echo rm -rf $TEST_GLOBROOT "# dry run: this line does not actually run, yet"
# rm -rf $TEST_GLOBROOT
