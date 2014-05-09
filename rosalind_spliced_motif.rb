load 'fasta.rb'

fasta = FASTA.new()

fasrecs = fasta.load_file "spliced_motif.fas"

File.open('results.txt', "w") do |output|   
  sample, target = fasrecs.values
  indices = []
  target.chars.each do |protein|    
    previous_index = indices.last || 0
    indices << (sample[previous_index..-1].index(protein) + 1 + previous_index)
  end    
  output.puts "#{indices.join(' ')}"  
end