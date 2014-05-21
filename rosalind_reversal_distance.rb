datum = File.open("data_reversal_distance.txt").readlines


File.open('results.txt', "w") do |output|   
  results = []
  while datum.first do
    goal = datum.rotate!.pop.split.map(&:to_i)
    altered = datum.rotate!.pop.split.map(&:to_i)
    datum.rotate!.pop #buffer space

    reversals = 0    
    candidates = [altered.clone]
    visited = Hash.new(false)
    visited[candidates.first] = true
    best_hamming = goal.zip(altered).select {|pair| pair[0] != pair[1] }.length
    while !candidates.index(goal) do
      new_candidates = []
      replacement_hamming = best_hamming      
      candidates.each do |candidate|        
        (0..8).each do |start| 
          (start+1..9).each do |endrange|
            before = candidate[0,start]
            swap = candidate[start..endrange]
            after = candidate[endrange+1..10]        
            possible = before+swap.reverse+after
            next if visited[possible]
            visited[possible] = true
            local_ham = goal.zip(possible).select {|pair| pair[0] != pair[1] }.length
            new_candidates.push possible if best_hamming+1 >= local_ham            
            replacement_hamming = [replacement_hamming, local_ham].min
          end
        end        
      end
      reversals += 1        
      candidates = new_candidates
      best_hamming = replacement_hamming
    end
    results.push(reversals)
  end
  output.puts "#{results.join(' ')}"
end