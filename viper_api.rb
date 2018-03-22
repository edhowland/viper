# viper_api.rb - various API editor functions

module ViperApi
  def self.getcmd()
    parse = {
      'j' => :j,
      'k' => :k,
      'h' => :h,
      'l' => :l,
      'd' => {
        'd' => :dd,
        'w' => :dw
      },
      'g' => { 'g' => :gg },
      'y' => { 'y' => :yy },
      'c' => {
        'c' => :cc,
        'w' => :cw
      },
      'Z' => { 'Z' => :ZZ },
    'q' => :q
    }
    ch = $stdin.getch
    x = parse[ch]
    if x.instance_of?(Hash)
      y = $stdin.getch
result = x[y]
    else
      result = parse[ch]
    end
    result
  end
end

Dispatch << ViperApi
