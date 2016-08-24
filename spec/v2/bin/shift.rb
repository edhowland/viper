# shift - class Shift - command shift - outputs first argument. See rotate fn 


class Shift < BaseCommand
  def call *args, env:, frames:
    super do |*a|
      pout @fs[:_].shift
    end
  end
end
