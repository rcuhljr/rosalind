load 'dna.rb'
File.open('results.txt', "w") do |output|	
	File.foreach("data_protein_encode.txt") do |line|		
		rna = RNA.new(line.chomp)		
		output.puts "#{rna.encode_protein}"
	end
end