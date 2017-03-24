# echo.rb - class Echo - command echo
# rubocop:disable Metrics/ParameterLists

class Echo < FlaggedCommand
  def initialize
    super(flags: { '-n' => false }) do |_inn, out, _err, _frames, flags, *args|
      if flags['-n']
        out.print args.join(' ')
      else
        out.puts args.join(' ')
      end
    end
    true
  end
end
