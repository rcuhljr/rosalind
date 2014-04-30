load 'dna.rb'
load 'fasta.rb'

fasta = FASTA.new()

fasrecs = fasta.load_file "orf_data.fas"

File.open('results.txt', "w") do |output|   
  seq = fasrecs.values.first
  RNA_base = DNA.new(seq).transcribe
  RNA_swap = DNA.new(seq).reverese_transcribe
  results = {}
  RNA_base.candidate_proteins.each{ |protein| results[protein] = true }
  RNA_swap.candidate_proteins.each{ |protein| results[protein] = true }
  results.keys.each{|protein| output.puts "#{protein}"}
end