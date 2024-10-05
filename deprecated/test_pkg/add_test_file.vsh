# add_test__file.vsh function to  source a  test filename and  then execute
# the  created  block


# adds a test file by  sourcing it and  executing the  new  renamed block
# of  test functions
fn add_test_file(fname) {
   source :fname
   var=:(filepart :fname)
   eval "exec ::{var}"
}
