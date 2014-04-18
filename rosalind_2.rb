load 'dna.rb'
File.open('results.txt', "w") do |output|
  File.foreach("data_2.txt") do |line|
    dna = DNA.new(line)
    output.puts "#{dna.transcribe}"
  end
end