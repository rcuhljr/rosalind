File.open('results.txt', "w") do |output| 
  File.foreach("pper_data.txt") do |line|   
    n, k = line.chomp.split.map(&:to_i)
    output.puts "#{n.downto(1).inject(&:*)/(n-k).downto(1).inject(&:*) % 1000000}"
  end
end