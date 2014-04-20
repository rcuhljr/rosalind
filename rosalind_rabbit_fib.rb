def rabbit_fib(months, litter_size)
  if(months < 3) then
    return 1
  end
  a, b = 1, 1
  
  (months-2).times {a, b = b, a*litter_size + b }  
  return b
end


File.open('results.txt', "w") do |output|  
  File.foreach("rabbit_data.txt") do |line|
    datum = line.chomp.scan(/\d+/)
    months = datum[0].to_i
    litter_pairs = datum[1].to_i
    output.puts "#{rabbit_fib(months, litter_pairs)}"
  end
end
