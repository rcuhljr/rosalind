load 'dna.rb'
load 'fasta.rb'
fasta = FASTA.new()

fasrecs = fasta.load_file "error_reads.fas"

File.open('results.txt', "w") do |output|   
  reads = fasrecs.values.clone
  read_library = Hash.new(0)
  reads.each do |read|
    read_library[read] += 1
    read_library[DNA.reverse_compliment(read)] += 1
  end
  good_reads = read_library.select{|_,count| count > 1}.keys
  error_reads = read_library.select{|key,count| count == 1 && reads.index(key)}.keys
  error_reads.each do |read| 
    fix = good_reads.select{|valid| DNA.hamming_distance(valid,read) == 1}.first
    output.puts "#{read}->#{fix}"
  end
  #reads.each{|x| output.puts "#{DNA.reverse_compliment(x)}:#{DNA.hamming_distance(x,"BBBBB")}"}   
end