#/usr/bin/env ruby


class Base
  def initialize something
    @thing = something
  end
end

class Sub < Base
  def my
    puts @thing
  end
end

if true
  o = My.new 'hello'
else
  puts 'nothing'
end

begin
  raise RuntimeError
rescue => err
  puts err.message
end
