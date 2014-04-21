def expected_offspring(populations)
   children = 2.to_f
   #AA-AA, AA-Aa, AA-aa, Aa-Aa, Aa-aa, aa-aa
   probabilities = [1, 1, 1, 0.75, 0.5, 0]
   pairs = populations.zip(probabilities)   
   expected_value = 0
   pairs.each{|pair| expected_value += pair[0]*pair[1]*children;}
   expected_value
end


File.open('results.txt', "w") do |output|  
  File.foreach("expected_data.txt") do |line|
    pops = line.chomp.scan(/\d+/).map(&:to_i)    
    output.puts "#{expected_offspring(pops)}"
  end
end
