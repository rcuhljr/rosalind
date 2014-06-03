load 'fasta.rb'
load 'dna.rb'

fasta = FASTA.new()

fasrecs = fasta.load_file "dist_matrix.fas"

def p_distance(start, target)
  DNA.new(start).hamming_distance(target).to_f/target.size
end

File.open('results.txt', "w") do |output|   
  samples = fasrecs.values
  sample_size = samples.size
  half_matrix = {}
  samples.each_with_index do |sample, outer_i|
    samples[outer_i..-1].each_with_index do |target, inner_i|
      half_matrix[[inner_i+outer_i,outer_i].sort] = p_distance(sample, target)
    end
  end  
  (0..sample_size-1).each{|row| (0..sample_size-1).each{|column| output.print "%.5f " % half_matrix[[row,column].sort] }; output.puts }  
end