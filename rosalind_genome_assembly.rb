load 'fasta.rb'

fasta = FASTA.new()

fasrecs = fasta.load_file "genome_assembly.fas"

File.open('results.txt', "w") do |output|   
  result, *sequences = fasrecs.values.clone 
  while sequences.length > 0 do    
    sequence, *sequences = sequences    
    n = sequence.length/2+(sequence.length%2)    
    offset = result.length-sequence.length   

    best_match = nil 
    best_match = result if result.include? sequence    
    
    (0..n).each do |i|        
      next if best_match     
      seq_right = sequence[i..-1]
      result_left = result[0..sequence.length-1-i] 
      seq_right_remainder = sequence[0,i]
      
      best_match = seq_right_remainder + result if seq_right == result_left      

      seq_left = sequence[0..sequence.length-1-i]
      result_right = result[offset+i..-1]   
      seq_left_remainder = sequence[sequence.length-i..-1]

      best_match = result + seq_left_remainder if seq_left == result_right
    end    
    result = best_match if best_match
    sequences << sequence unless best_match
  end
  output.puts "#{result}"  
end