load 'dna.rb'

File.foreach("data_1.txt") do |line|
	dna = DNA.new(line)
	puts "#{dna.nucleotide_counts["A"]} #{dna.nucleotide_counts['C']} #{dna.nucleotide_counts['G']} #{dna.nucleotide_counts['T']}"
end