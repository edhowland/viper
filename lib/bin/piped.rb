# piped.rb: class Piped - Did the args of the commandspecify a dash, then yes
# Usage:
# p = Piped.new args
# puts p.piped?
# args will delete the arg from args if it is a "-" dash

class Piped
  def initialize args
    @piped = !!args.find {|e| e == "-" }
    args.delete("-")
  end
  def piped?
    @piped
  end
  def inspect
    "Does " + (piped? ? "" : "not") + " read from stdin"
  end
  def to_s
    inspect
  end
end
