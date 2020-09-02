# stub.rb - method stub responses block - creates a stub object that responds
# to canned method calls

require 'ostruct'

class Stub
            def create_method(name, &block)
              self.class.send(:define_method, name, &block)
                end
end

def stub **sigs, &blk
  s = Stub.new
  sigs.each_pair do |m, r|
    s.create_method m, &->(*a, **k) { r }
  end
  yield(s) if block_given?
end