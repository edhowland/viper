# nop - class Nop - No operation command

class Nop < BaseCommand
  def call(*args, env:, frames:)
    result = true
    super do |*a|
      result = a[0] if a.length == 1
    end
    result
  end
end
