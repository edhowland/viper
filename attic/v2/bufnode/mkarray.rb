# mkarray - class Mkarray - command mkarray path - creates Array node at path

class Mkarray < BaseCommand
  def call *args, env:, frames:
    super do |*a|
    root   = @fs[:vroot]
      dnode = root.dirnode a[0]
      base = root.basename a[0]
      dnode[base] = []
    end
  end
end

