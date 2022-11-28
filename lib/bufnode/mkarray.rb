# mkarray - class Mkarray - command mkarray path - creates Array node at path

class Mkarray < BaseCommand
  def call(*args, env:, frames:)
    #super do |*a|
      root = frames[:vroot]
      dnode = root.dirnode args[0]
      base = root.basename args[0]
      dnode[base] = []
    #end
  end
end
