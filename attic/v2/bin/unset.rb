# unset - class Unset - command unset - unsets a variable

class Unset < BaseCommand
  def call *args, env:, frames:
    super do |*a|
      if a.empty?
        perr 'unset: must supply a variable'
        false
      else
        frames.delete a[0].to_sym
        true
      end
    end
  end
end
