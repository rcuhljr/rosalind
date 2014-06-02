load 'fasta.rb'

fasta = FASTA.new()

fasrecs = fasta.load_file "kmer.fas"

File.open('results.txt', "w") do |output|   
  kmer = 4
  alphabet = "ACGT"
  sample = fasrecs.values.first
  counts = Hash.new(0)
  possible_keys = alphabet.chars.repeated_permutation(kmer).map{|x| x.join}.sort
  (0..sample.size-kmer).each{|index| counts[sample[index..(index+kmer-1)]] += 1}
  output.puts "#{possible_keys.map{|key| counts[key]}.join(' ')}"  
end