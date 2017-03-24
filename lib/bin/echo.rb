# echo.rb - class Echo - command echo

class Echo < FlaggedCommand
  def initialize
    super(flags:{'-n' => false}) do |inn, out, err, frames, flags, *args|
      if flags['-n']
        out.print args.join(' ')
      else
        out.puts args.join(' ')
      end
    end
    true
  end
end
