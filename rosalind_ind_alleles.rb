require 'bernoulli'

def independent_alleles(k, n)
  dist = Bernoulli::Distribution::Binomial.new(2**k, 1.0/4)
  dist[n..2**k]
end


File.open('results.txt', "w") do |output|  
  File.foreach("i_alleles_data.txt") do |line|
    k, n = line.chomp.scan(/\d+/).map(&:to_i)    
    output.puts "#{independent_alleles(k, n)}"
  end
end
