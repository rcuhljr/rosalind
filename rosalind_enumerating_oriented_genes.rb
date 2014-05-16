File.open('results.txt', "w") do |output|   
  File.foreach('enum_oriented.txt') do |line|    
      perm_size = line.chomp.to_i
      orders = (1..perm_size).map{|x| [x,-x]}.flatten.permutation(perm_size).to_a
      orders = orders.select{|x| x.map(&:abs).uniq.size == perm_size}

    
      output.puts "#{orders.size}"      
      orders.each{|x| output.puts "#{x.join(' ')}"  }
  end
end