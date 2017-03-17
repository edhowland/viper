# datetime - class Datetime - command datetime - prints date/time

class Datetime < BaseCommand
  def call(*args, env:, frames:)
    super do |*_a|
      env[:out].puts Time.now
    end
  end
end
