# shift - class Shift - command shift - outputs first argument. See rotate command
# shifts from left of :_, which is the remainder of arguments past last named one
# args:
#  Must have at least one argument which must be a variable
# if multiple arguments, which must all be be variables, then this mumber of arguments will be shifted off :_
# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/PerceivedComplexity

class Shift < BaseCommand
  def call(*args, env:, frames:)
    super do |*a|
    src = '_'.to_sym

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
