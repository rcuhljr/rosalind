load 'dna.rb'
load 'fasta.rb'

fasta = FASTA.new()

o_size = 3

fasta_data = fasta.load_file 'data_ol_graph.fas'

File.open('results.txt', "w") do |output|   
  prefixes = {}
  postfixes = {}
  fasta_data.each do |record, sequence|        
    fasrec = [record, sequence]
    pre = sequence[0..(o_size-1)]
    post = sequence[(-1*o_size)..-1]
    prefixes[pre] = (prefixes[pre] || []) << fasrec
    postfixes[post] = (postfixes[post] || []) << fasrec     
  end
  postfixes.each do |postKey, postValue|
    postValue.each do |postFasrec|
      (prefixes[postKey]||[]).each do |record, sequence|        
        output.puts "#{postFasrec[0]} #{record}" unless postFasrec[0] == record        
      end
    end
  end
end