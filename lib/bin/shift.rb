# shift - class Shift - command shift - outputs first argument. See rotate fn
# args:
# -s <input array> : Use this input (which must be a variable name) instead of :_
# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/PerceivedComplexity

class Shift < BaseCommand
  def call(*args, env:, frames:)
    super do |*a|
    if @options[:s]
      src = a.shift.to_sym 
    else
      src = '_'.to_sym
    end

      if a.length.zero?
        perr 'shift: missing variable argument'
        result = false
      else
      object = @fs[src]
puts "object.class: #{object.class.name}. inspecting: #{object.inspect}"
    raise RuntimeError.new("shift: cannot shift non-array type") unless object.kind_of?(Array)
      zh = a.map(&:to_sym).zip(object.shift(a.length))
puts "zh.class: #{zh.class.name} inspecting: #{zh.inspect}"
#      frames.top.merge(zh.to_h)
      zh.each {|k, v| frames[k] = v }
      frames.merge
      result = true
      end
=begin

      object = object.split(frames[:ifs]) if object.instance_of?(String)
      result = true
      if object && object.instance_of?(Array) && !object.empty?
        value = object.shift
        @fs[src] = object
      elsif object.instance_of?(String)
        value = object
      else
        perr "shift: invalid argument: #{src}: #{@fs[src].class}"
        result = false
      end
      if a.length.zero?
        perr 'shift: missing variable argument'
        result = false
      end
      if result
        @fs[a[0].to_sym] = value
        @fs.merge
      end
=end
      result
    end
  end
end
