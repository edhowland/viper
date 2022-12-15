# ls - class Ls - Unix-like ls command

## Usage: ls [list [...]]
#
# Differs from *nix ls:
# Output for found dirs in list are preceeded by the directory part:
# ls aa1
# aa1/bar.txt
# aa1/foo.txt
# aa1/none.xxx

# Also, the behaviour of 'ls -1' is  always  output, as the example above shows,
# in order to aid usage with screen reader users.

## Options: none
# A future option might be -d.

class Ls < BaseCommand
class LsDir
  def initialize name, entries=[]
    @name = name
    @entries = entries
  end
  attr_reader :name, :entries
  def to_s
    @entries.join("\n")
  end
  def directory?
    true
  end
end
class LsFile
  def initialize name
    @name = name
  end
  attr_reader :name
  def to_s
    @name
  end
  def directory?
    false
  end
  def <=>(that)
    self.name <=> that.name
  end
end

  def dir_star(path)
    if Hal.directory?(path)
      "#{path}/*"
    else
      path
    end
  end


def entry name
  Promise.new {|p|   Hal.exist?(name) ? p.resolve!(name) : p.reject!(name) }.then {|v| Hal.directory?(v) ? LsDir.new(v, Hal["#{v}/*"]) : LsFile.new(v) }
end
def l1 *entries, err:
  if entries.empty?
    return Hal['*']
  end
  p = Promise.all_selected(entries.map {|e| entry(e) })
  p.run
  errs = p.aggregate_errors
  vals = p.aggregate_values

  errs.each {|e| err.puts "ls: #{e}: No such file or directory" }

  files = vals.reject(&:directory?)
  dirs = vals.select(&:directory?)
  files.sort!
  #puts files
  #puts dirs
    files + dirs
end

  def call(*args, env:, frames:)
    env[:out].puts l1(*args, err: env[:err])

  end
end
