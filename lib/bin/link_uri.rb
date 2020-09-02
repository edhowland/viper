# link_uri.rb - class LinkUri - command link_uri /v/path/to/array - reports link attribute
# of first element in array

class LinkUri < BaseCommand
  def call *args, env:, frames:
    path = args.first
    array = Hal.open(path, 'r').io
    item = array.first
    raise 'No link here' unless Link === item
    env[:out].puts item.link
    true
  end
end