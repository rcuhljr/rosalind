load 'fasta.rb'
fasta = FASTA.new()

$memo_matches = Hash.new(false)

def match_info(sub, target)  
  $memo_matches[sub] if $memo_matches[sub].nil? || $memo_matches[sub]    
  full = target.size
  target = target.clone
  remainder = true;
  sub.chars.each do |char|    
      if target.length == 0 || target.index(char).nil?
        remainder = false
        break
      end
      target = target[target.index(char)+1..-1]
  end
  $memo_matches[sub] = remainder ? [sub,full - target.size] : nil
end

fasrecs = fasta.load_file "long_com_sub.fas"

File.open('results.txt', "w") do |output|     
  source, target = fasrecs.values
  candidates = [[source[0], 1]]  
  source[1..-1].chars.each do |character|     
    candidates.clone.each do |candidate|                  
      potential = candidate.first + character            
      data = match_info(potential, target)            
      next unless data

      next if candidates.select {|x| x.first.size >= data.first.size && x.last <= data.last}.length > 0
      
      tie = candidates.index{|x| x.first.size == data.first.size}
      if tie 
        
        next if candidates[tie].last <= data.last
        
        candidates.delete_at(tie)
      end      
      candidates.delete(candidate) if (candidate.last+1) == data.last
            
      candidates.reject!{|x| x.first.size <= data.first.size && x.last >= data.last }
      
      candidates.push data
      
    end    
  end
  output.puts "#{candidates.max_by{|x| x.first.size}.first}"
end