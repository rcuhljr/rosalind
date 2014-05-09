File.open('results.txt', "w") do |output|   
  sub_size = nil

  File.foreach('long_sub.txt') do |line|
    if(!sub_size)
      sub_size = line.chomp.to_i
    else
      pi = line.chomp.split.map(&:to_i)
      inc_seq, dec_seq = [],[]
      count = 0
      pi.each do|i|
        count += 1        
        inc_min, inc_max = inc_seq.minmax_by{|x| x.last}
        longest_inc_list = inc_seq.max_by{|x| x.size}
        if inc_seq.size == 0 || i < inc_min.last 
          inc_seq.delete_if {|x| x.size == 1}
          inc_seq << [i]
        elsif i > inc_max.last
          inc_seq << (longest_inc_list.clone << i)
        else
          target = inc_seq.select{|x| x.last < i}.max_by{|x| x.last}          
          target = (target.clone << i)
          inc_seq.delete_if{|x| x.size == target.size}
          inc_seq << target          
        end

        dec_min, dec_max = dec_seq.minmax_by{|x| x.last}
        longest_dec_list = dec_seq.max_by{|x| x.size}
        if dec_seq.size == 0 || i > dec_max.last           
          dec_seq.delete_if {|x| x.size == 1}
          dec_seq << [i]
        elsif i < dec_min.last
          dec_seq << (longest_dec_list.clone << i)
        else
          target = dec_seq.select{|x| x.last > i}.min_by{|x| x.last}                    
          target = (target.clone << i)
          dec_seq.delete_if{|x| x.size == target.size}
          dec_seq << target           
        end
      end
      output.puts "#{inc_seq.max_by{|x| x.size}.join(' ')}"      
      output.puts "#{dec_seq.max_by{|x| x.size}.join(' ')}"  
    end
  end
end