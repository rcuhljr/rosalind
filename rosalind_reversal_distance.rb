datum = File.open("data_reversal_distance.txt").readlines


File.open('results.txt', "w") do |output|   
  results = []
  while datum.first do
    goal = datum.rotate!.pop.split.map(&:to_i)
    altered = datum.rotate!.pop.split.map(&:to_i)
    datum.rotate!.pop #buffer space

    reversals = 0
    puts "#{goal}"
    goal.reverse.each do |item| 
      puts "#{altered}"
      target = goal.index(item)
      distance = altered.index(item)
      reversals += 1 if target != distance
      puts "reversals: #{reversals}"
      puts "#{target}: #{distance}"
      before = altered[0..[distance-1,0].max]
      swap = altered[distance..target]
      after = altered[target+1..goal.size]
      puts "#{before}:#{swap}:#{after}"
      altered =  before + swap.reverse + after
    end
    results.push(reversals)
  end
  output.puts "#{results.join(' ')}"
end