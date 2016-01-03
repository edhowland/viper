# recordable.rb - module Recordable

module Recordable
  def record method, *args
    @commands ||= CommandBuffer.new
    @commands << [method, *args]
    end
end
