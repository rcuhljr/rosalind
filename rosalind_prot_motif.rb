require 'net/http'
load 'fasta.rb'

uri_format = "http://www.uniprot.org/uniprot/%s.fasta"
fasta = FASTA.new()

File.open('results.txt', "w") do |output|   
  File.foreach("uniprot_data.txt") do |line|   
    id =line.chomp    
    response = Net::HTTP.get_response(URI(uri_format % [id]))    
    while response.code != "200"
      location = response['location']
      location = 'http://www.uniprot.org' + location if location[0] == '/'
      response = Net::HTTP.get_response(URI(location))
    end
    fasrecs = fasta.load_string(response.body.chomp)
    prot_string = fasrecs.values[0]
    matches = [] 
    offset = 0
    while prot_string[offset..-1] =~ /N[^P][ST][^P]/      
      matches << Regexp.last_match.begin(0) + 1 + offset
      offset = matches.last      
    end

    if matches.length > 0 then
      output.puts "#{id}"
      output.puts "#{matches.join(' ')}"
    end
  end  
end