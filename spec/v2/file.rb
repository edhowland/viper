begin
  File.open __FILE__, 'r'
  puts 'should get here'
rescue => err
  puts 'should not get here'
end