#k hom dom, m het, n hom rec
def mendel_dominant(k, m, n)
  total = (k+m+n).to_f
  #chance a k is drawn first
  dominant = k/total  
  #chance a k is drawn after an n or m
  dominant += (1-k/total)*k/(total-1)
  #chance of 75% expression for m m
  dominant += 0.75 * (m/total*(m-1)/(total-1))  
  #chance of 50% expression for m n or n m
  dominant += 0.5 * ((m/total*n/(total-1)) + (n/total*m/(total-1)))    
  
end


File.open('results.txt', "w") do |output|  
  File.foreach("mendel_data.txt") do |line|
    datum = line.chomp.scan(/\d+/)
    k,m,n = datum.map(&:to_i)    
    output.puts "#{mendel_dominant(k,m,n)}"
  end
end
