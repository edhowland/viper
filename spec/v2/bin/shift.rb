# shift - class Shift - command shift - outputs first argument. See rotate fn 
# args:
# -s <input array> : Use this input instead of :_

class Shift < BaseCommand
  def call *args, env:, frames:
    super do |*a|
      src = '_'.to_sym
            src = a.shift.to_sym if @options[:s]
      object = @fs[src]
      object = object.split if object.instance_of?(String)
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
        perr "shift: missing variable argument"
        result = false
      end
      if result
        @fs[a[0].to_sym] = value
        @fs.merge
      end
      result
    end
  end
end
