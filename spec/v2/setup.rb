class Setup
def initialize
@r=VFSRoot.new
@r._mkdir ['home', 'edh', 'bin']
@r._chdir ['home', 'edh']

@a=['home','edh']
@path = '/home/edh'
@rel = 'bin'
end
attr_accessor :r, :path, :a, :rel
end
