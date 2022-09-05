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
    raise RuntimeError.new("shift: cannot shift non-array type") unless object.kind_of?(Array)
      zh = a.map(&:to_sym).zip(object.shift(a.length)).map {|k, v| [k, v.nil? ? '' : v] }
      zh.each {|k, v| frames[k] = v }
      frames.merge
      result = true
      end

      result
    end
  end
end
