  def self._getcmd()
    parse = {
      "\u0012" => :ctrl_r,
      '#' => :hash,
      '<' => :langle,
      '>' => :rangle,
      ':' => :colon,
      '/' => :fslash,
      'n' => :n,
      'N' => :N,
      '?' => :question,
      '.' => :period,
      'f' => :f,
      'F' => :F,
      'w' => :w,
      'W' => :W,
      'j' => :j,
      'k' => :k,
      'h' => :h,
      'l' => :l,
      ' ' => :l,
      'L' => :L,
      'i' => :i,
      'I' => :I,
      'o' => :o,
      'O' => :O,
      'a' => :a,
      'A' => :A,
      'u' => :u,
      'r' => :r,
      '0' => :zero,
      '$' => :dollar,
      'p' => :p,
      'm' => { 'm' => :mm },
      'd' => {
        'd' => :dd,
        'w' => :dw,
        "'" => :dquote_m,
        'G' => :dG,
        '0' => :d0,
        '$' => :d_dollar,
        'g' => :dg
      },
      'g' => { 'g' => :gg },
      'G' => :G,
      'y' => { 
        'y' => :yy,
        "'" => :yquote_m
       },
      'Y' => :yy,
      'c' => {
        'c' => :cc,
        'w' => :cw
      },
      'x' => :x,
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
    [1, result]
  end
