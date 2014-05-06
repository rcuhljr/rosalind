File.open('results.txt', "w") do |output| 
  branches = nil
  File.foreach("tree_data.txt") do |line|   
    if line.chomp.split.length == 1
      branches = (1..(line.chomp.to_i)).to_a.map{|x| [x]}
      next
    end
    n, k = line.chomp.split.map(&:to_i)
    matches = branches.select{|x| (x & [n,k]).length > 0}
    branches.reject!{|x| (x & [n,k]).length > 0}
    keep, *remove = matches

    keep |= [n,k]

    remove.each{|branch| keep |= branch}

    branches << keep
  end
  output.puts "#{branches.size-1}"
end