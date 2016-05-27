# handle_back_tab.rb - method handle_back_tab for key :back_tab

def handle_back_tab buffer
  indent_level = Viper::Variables[:indent]
  # initial attempt
  indent_level.times { buffer.del }
  say 'back tab'
end
