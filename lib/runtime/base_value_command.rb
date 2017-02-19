# base_value_command - class BaseValueCommand -  abstract base class that parses
# option flags into arguments into @options hash


class BaseValueCommand < BaseCommand
  def args_parse! args
    args = super
    @options.keys.each do |k|
      @options[k] =args.shift
    end
    args
  end

  def arg_to_i key
    @options[key] = @options[key].to_i if @options[key]
  end
end
