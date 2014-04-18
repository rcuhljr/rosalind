load 'dna.rb'

File.foreach("data_2.txt") do |line|
	dna = DNA.new(line)
	puts "#{dna.transcribe}"
end