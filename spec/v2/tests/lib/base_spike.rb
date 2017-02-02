# buffer base_spike.rb - class BaseSpike - base class for Spike test suites

class BaseSpike
  def self.descendants
      ObjectSpace.each_object(Class).select { |klass| klass < self }
  end

  def self.tests
    instance_methods.select {|e| e =~ /^test/ }
  end
  def try sym, *args
    self.send sym, *args if self.respond_to? sym
  end
end
