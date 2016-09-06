# pathmap - class  Pathmap - command pathmap - works like Rake's pathmap 

class Pathmap < BaseCommand
  def call *args, env:, frames:
    super do |*a|
      pout "pathmap"
    end
  end
end

