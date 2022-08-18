# my_stub.rb - method my_stub responses block - creates a MyStub object that responds
# to canned method calls

require 'ostruct'

class MyStub
  def create_method(name, &block)
    self.class.send(:define_method, name, &block)
  end
end

def my_stub **sigs, &blk
  s = MyStub.new
  sigs.each_pair do |m, r|
    s.create_method m, &->(*a, **k) { r }
  end
  yield(s) if block_given?
end