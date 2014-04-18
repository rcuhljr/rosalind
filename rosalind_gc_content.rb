load 'dna.rb'
load 'fasta.rb'

fasta = FASTA.new()

fasta_data = fasta.load_file 'data_gc.fas'

File.open('results.txt', "w") do |output|	
	label = nil
	ratio = -1
	fasta_data.each do |record, sequence|
		dna = DNA.new(sequence)
		if ratio < dna.gc_content then
			ratio = dna.gc_content
			label = record
		end
	end
	output.puts "#{label}"
	output.puts "#{ratio*100}"
end