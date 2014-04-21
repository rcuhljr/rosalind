
def rabbit_fib_mort(months, lifespan)
  babies = [1, 0]
  adults = [0, 1]
  if(months < 3) then
    return 1
  end  
  
  offset = 2
  
  (months-offset).times do |x|    
    #all adults from last year have children
    babies << adults.last
    #all babies from last year become adults
    adults << adults.last + babies[-2]
    #all babies from lifespan months back die    
    adults[-1] = adults[-1] - babies[x-(lifespan-offset)] if (lifespan-offset) <= x   
        
  end
  return babies.last+adults.last
end

File.open('results.txt', "w") do |output|  
  File.foreach("rabbit_data_mort.txt") do |line|
    datum = line.chomp.scan(/\d+/)
    months,lifespan = datum.map(&:to_i)     
    output.puts "#{rabbit_fib_mort(months, lifespan)}"
  end
end
