load 'dna.rb'
load 'fasta.rb'

fasta = FASTA.new()

fasrecs = fasta.load_file "common_ss_data.fas"

File.open('results.txt', "w") do |output|   
  substring = DNA.longest_common_substring fasrecs.values  
  output.puts "#{substring}"
end