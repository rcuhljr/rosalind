datum = File.open("data_rand_motif_match.txt").readlines


File.open('results.txt', "w") do |output|   
  n = datum.first.split().first.to_i
  pGC = datum.first.split().last.to_f

  prob_hash = {'A'=>(1-pGC)/2, 'T'=>(1-pGC)/2, 'G'=>pGC/2, 'C'=>pGC/2}
  prob = datum.last.chars.map{|x| prob_hash[x]}.inject(:*)
  puts "#{prob}"
  output.puts "#{1-(1-prob)**n}"
end