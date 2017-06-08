# mdparse.rb - class  Mdparse - command mdparse file.md /v/array - parses 
# markdown file and places Elements in passed path to array
# will create array

class Mdparse < BaseCommand
  def call(*args, env:, frames:)
    fname, apath = args
    array = []
    parser = parse_md(array)
    file = File.read(fname)
    parser.render file
    st = Store.new
    st.call array, apath, env: env, frames: frames
    true
  end
end
