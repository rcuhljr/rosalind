load 'dna.rb'
load 'fasta.rb'

fasta = FASTA.new()

fasrecs = fasta.load_file "data_pm.fas"

File.open('results.txt', "w") do |output|   
  rna = RNA.new(fasrecs.values.first)
  output.puts "#{rna.perfect_matches}"
end