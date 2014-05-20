load 'fasta.rb'
fasta = FASTA.new()

fasrecs = fasta.load_file "cat_num_rna.fas"

$memos = {}

def count_perfect_noncrossing(sequence, mod, debug)
  folding_matches = {'A'=> 'U', 'U'=> 'A', 'C'=>'G', 'G'=> 'C'}    
  result = 0
  return $memos[sequence] if $memos[sequence]
  if sequence.size == 0 || (sequence.size == 2 && folding_matches[sequence[0]] == sequence[1]) 
    $memos[sequence] = 1
    return 1
  end
  (1..sequence.size/2).map{|x| x*2}.each do |index|    
    next if folding_matches[sequence[0]] != sequence[index-1]
    front, back = [sequence[1..index-2], sequence[index..sequence.size]]
    next unless balanced_string(front) && balanced_string(back)    
    result += count_perfect_noncrossing(front, mod, debug) * count_perfect_noncrossing(back, mod, debug)
    result = result % mod
  end
  $memos[sequence] = result
end

def balanced_string(sequence)  
  sequence.count("A") == sequence.count("U") && sequence.count("G") == sequence.count("C")
end


File.open('results.txt', "w") do |output|   
  target = fasrecs.values.first
  
  output.puts "#{count_perfect_noncrossing(target, 1000000, output)}"  
end