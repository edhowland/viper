# link_uri.rb - class LinkUri - command link_uri /v/path/to/array - reports link attribute
# of first element in array

class LinkUri < BaseCommand
  def call *args, env:, frames:
    raise 'Nothing to link to yet'
    true
  end
end