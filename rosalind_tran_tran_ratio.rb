load 'fasta.rb'
load 'dna.rb'

fasta = FASTA.new()

fasrecs = fasta.load_file "transitions.fas"

File.open('results.txt', "w") do |output|   
  sample, target = fasrecs.values  
  output.puts "#{DNA.new(sample).transition_tranversion_ratio(target)}"  
end