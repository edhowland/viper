# mdparse.rb - class  Mdparse - command mdparse file.md /v/array - parses 
# markdown file and places Elements in passed path to array
# will create array

class Mdparse < BaseCommand
  def call(*args, env:, frames:)
    fname, apath = args
    array = []
    rend = MdRender.new
    parser = parse_md(array, rend)
    file = File.read(fname)
    parser.render file
    rend = parser.renderer
    array = rend.expand

    st = Store.new
    st.call array, apath, env: env, frames: frames
    true
  end
end
