load 'dna.rb'

File.open('results.txt', "w") do |output|
  File.foreach("mrna_data.txt") do |line|        
    output.puts "#{RNA.possible_rna_mod(line.chomp, 1000000)}"
  end
end