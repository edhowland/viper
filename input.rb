 
require 'io/console'
 
def yesno
  case $stdin.getch
    when "Y" then true
    when "N" then false
    else raise "Invalid character."
  end
end

print 'type either Y or N: '
if yesno
  puts 'answered yes'
else
  puts 'you answered no'
end


