load 'dna.rb'
File.open('results.txt', "w") do |output|
  dna = nil
  File.foreach("data_point_mutations.txt") do |line|
    if !dna
      dna = DNA.new(line.chomp)
      next
    end
    output.puts "#{dna.hamming_distance(line.chomp)}"
  end
end