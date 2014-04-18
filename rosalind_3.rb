load 'dna.rb'

File.open('results.txt', "w") do |output|
  File.foreach("data_3.txt") do |line|
    dna = DNA.new(line)
    output.puts "#{dna.reverse_compliment}"
  end
end