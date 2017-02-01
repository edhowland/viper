# buffer base_spike.rb - class BaseSpike - base class for Spike test suites

class BaseSpike
  def self.descendants
      ObjectSpace.each_object(Class).select { |klass| klass < self }
  end

  def self.tests
    instance_methods.select {|e| e =~ /^test/ }
  end
end
