load 'dna.rb'
File.open('results.txt', "w") do |output|
	dna = nil
	File.foreach("data_motif.txt") do |line|
		if !dna
			dna = DNA.new(line.chomp)
			next
		end
		output.puts "#{dna.motif_locations(line.chomp).join(' ')}"
	end
end