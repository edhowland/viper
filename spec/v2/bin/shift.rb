# shift - class Shift - command shift - outputs first argument. See rotate fn 

class Shift < BaseCommand
  def call *args, env:, frames:
    super do |*a|
      @fs[a[0].to_sym] = @fs[:_].shift
      @fs.merge
    end
    true
  end
end
