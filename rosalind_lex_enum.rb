File.open('results.txt', "w") do |output|   
  alphabet = nil
  File.foreach('lex_enum.txt') do |line|
    if(!alphabet)
      alphabet = line.chomp.split
    else
      alphabet.repeated_permutation(line.chomp.to_i).to_a.map{|x| output.puts x.join}
    end
  end
end