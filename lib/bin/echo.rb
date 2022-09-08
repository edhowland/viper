# echo.rb - class Echo - command echo
# rubocop:disable Metrics/ParameterLists

class Echo < FlaggedCommand
  def initialize
    super(flags: { '-n' => false, '-x' => false }) do |_inn, out, _err, _frames, flags, *args|
      result = true
      if flags['-n']
        out.print args.join(' ')
      elsif flags['-x']
        if args.length.zero?
          _err.puts "echo: -x requires exactly one argument"
          result = false
        else
                out.puts  args[0].chars.map(&:ord)
        end
      else
        out.puts args.join(' ')
      end
result
    end
  end
end
