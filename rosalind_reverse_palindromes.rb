load 'dna.rb'
load 'fasta.rb'

fasta = FASTA.new()

fasrecs = fasta.load_file "data_rp.fas"

File.open('results.txt', "w") do |output|   
  dna = DNA.new(fasrecs.values.first)
  dna.reverse_palindromes.sort.each {|palindrome| output.puts "#{palindrome.join(' ')}"}  
end