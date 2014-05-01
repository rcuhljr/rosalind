load 'dna.rb'
load 'fasta.rb'

fasta = FASTA.new()

fasrecs = fasta.load_file "splicing_data.fas"

File.open('results.txt', "w") do |output|   
  dna_seq = fasrecs.values.first
  introns = fasrecs.values[1..-1]

  introns.each { |intron| dna_seq.gsub!(/#{intron}/, '') }

  RNA_base = DNA.new(dna_seq).transcribe
  output.puts "#{RNA_base.encode_protein}"
end