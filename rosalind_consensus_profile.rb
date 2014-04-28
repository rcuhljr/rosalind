require 'net/http'
load 'fasta.rb'

fasta = FASTA.new()

fasrecs = fasta.load_file "con_profile.fas"

File.open('results.txt', "w") do |output|   
  size = fasrecs.values.first.length
  profile_matrix = {"A"=>Array.new(size,0),"C"=>Array.new(size,0),"G"=>Array.new(size,0),"T"=>Array.new(size,0)}
  matrix_index = {0=>"A", 1=>"C", 2=>"G", 3=>"T"}
  fasrecs.values.each do |dna_string|
    dna_string.chars.each_with_index {|nucleotide, index | profile_matrix[nucleotide][index] += 1 }
  end
  
  profile_matrix["A"].zip(profile_matrix["C"], profile_matrix["G"], profile_matrix["T"]).each do|column| 
    output.print matrix_index[column.each_with_index.max()[1]]
  end
  output.puts ""
  profile_matrix.each {|nucleotide, counts| output.puts "#{nucleotide}: #{counts.join(' ')}" } 
  
end