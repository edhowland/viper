# false - class False  - command false - returns false

class False < BaseCommand
  def call *args, env:, frames:
    super { false }
  end
end
