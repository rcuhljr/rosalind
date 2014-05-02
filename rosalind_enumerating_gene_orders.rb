n = 5

File.open('results.txt', "w") do |output|   
  perms = (1..n).to_a.permutation(n).to_a
  output.puts "#{perms.size}"
  perms.each {|perm| output.puts "#{perm.join(' ')}" }
end