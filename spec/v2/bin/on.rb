# on - class On - command on - manages event handlers
# args:
# -k  deletes (kills) handler
# -l : lists (all) handler(s)


class On < BaseCommand
  def call *args, env:, frames:
    super do |*a|
      handler = a.pop
      Event <<  handler
    end
  end
end
