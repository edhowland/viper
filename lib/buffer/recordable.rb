# recordable.rb - module Recordable

module Recordable
  def record method, *args
    @commands ||= []
    @commands << [method, *args]
    end
end
