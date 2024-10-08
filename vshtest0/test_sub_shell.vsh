# tests for subshells
fn test_cloned_vm_does_not_change_pwd_of_parent_vm()  {
   x_pwd=:pwd
   (cd /v;pwd)
   assert_eq :x_pwd :(pwd)
}
