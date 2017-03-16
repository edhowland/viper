# pathmap - class  Pathmap - command pathmap - works like Rake's pathmap

class Pathmap < BaseCommand
  def call *args, env:, frames:
    super do |*a|
      if a.length == 2
        pout a[1].pathmap(a[0])
      else
        perr "pathmap: Expected 2 arguments, got: #{a.length}"
        false
      end
    end
  end
end
