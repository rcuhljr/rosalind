load 'dna.rb'
File.open('results.txt', "w") do |output| 
  File.foreach("prot_weight_data.txt") do |line|   
    protein_string = line.chomp
    output.puts "#{RNA.protein_weight(protein_string)}"
  end
end