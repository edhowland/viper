# lambda_function.rb: module LambdaFunction < Function
# Wraps a Lambda in a Function
# For use with the 'defn' keyword
# defn foo &() { echo I am Foo }
# $vm.fs.functions[:foo] will be a LambdaFunction
#  type foo
# function

module LambdaFunction
  attr_accessor :name
end