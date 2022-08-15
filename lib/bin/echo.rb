# echo.rb - class Echo - command echo
# rubocop:disable Metrics/ParameterLists

class Echo < FlaggedCommand
  def initialize
    super(flags: { '-n' => false, '-x' => false }) do |_inn, out, _err, _frames, flags, *args|
      if flags['-n']
        out.print args.join(' ')
      elsif flags['-x']
        puts  args[0].chars.map(&:ord)
      else
        out.puts args.join(' ')
      end
      true
    end
  end
end
