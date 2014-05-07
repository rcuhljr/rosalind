File.open('results.txt', "w") do |output| 
  sequence = nil
  File.foreach("rand_data.txt") do |line|   
    if line.chomp.split.length == 1
      sequence = line.chomp
      next
    end
    gc_contents = line.chomp.split.map(&:to_f)
    probabilities = []
    gc_contents.each do |gc|
      gc_prob = Math.log(gc/2,10)
      at_prob = Math.log((1-gc)/2,10)
      probabilities << sequence.chars.reduce(0){|acc, char| acc + (/[GC]/ =~ char ? gc_prob : at_prob)}.round(3)
    end
    output.puts "#{probabilities.join(' ')}"
  end  
end