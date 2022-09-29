# lambda_function.rb: class LambdaFunction < Function
# Wraps a Lambda in a Function
# For use with the 'defn' keyword
# defn foo &() { echo I am Foo }
# $vm.fs.functions[:foo] will be a LambdaFunction
#  type foo
# function

class LambdaFunction < Function
  def initialize(l, name='anon')
    super(l.args, l.block, name)
  end
end