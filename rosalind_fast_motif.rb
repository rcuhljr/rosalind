load 'fasta.rb'
fasta = FASTA.new()

fasrecs = fasta.load_file "fast_motif.fas"

File.open('results.txt', "w") do |output|   
  result = [0]
  target = fasrecs.values.first
  target[1..-1].chars.each_with_index do |char,index| 
    #puts "#{result}"
    if char == target[result.last]
      result.push(1 + result.last) 
      next
    end
    match_length = 0
    subtarget = target[0..index+1]
    (1..result.last).each do |offset|
      #puts "#{target[0..offset-1]} : #{subtarget[-1*offset..-1] } "
      match_length = offset if target[0..offset-1] == subtarget[-1*offset..-1] 
    end
    result.push(match_length)
  end  
  output.puts "#{result.join(' ')}"
  
  #reads.each{|x| output.puts "#{DNA.reverse_compliment(x)}:#{DNA.hamming_distance(x,"BBBBB")}"}   
end