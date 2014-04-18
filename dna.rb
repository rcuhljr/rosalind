class MacroMolecule
  @@symbols = ['A', 'G', 'C']    

  def initialize sequence
    raise ArgumentError.new "Sequence contains non DNA symbols." if illegal_characters? sequence

    @sequence = sequence    
  end

  def count nucleotide
    raise ArgumentError.new "Unrecognized Nucleotide: #{nucleotide}" unless @@symbols.include? nucleotide

    @sequence.count(nucleotide)
  end

  def nucleotide_counts
    @dna_count ||= dna_count
  end

  def to_s
    @sequence
  end

  private
  def dna_count     
    @@symbols.each_with_object({}) {|acid, counts| counts[acid] = count acid }    
  end  

  def illegal_characters? sequence
    sequence.index(/[^#{@@symbols.join}]/)
  end

end

class DNA < MacroMolecule
  @@symbols = @@symbols | ['T']
  @@compliments = {'A'=> 'T', 'T'=> 'A', 'C'=>'G', 'G'=> 'C'}

  def transcribe
    RNA.new(@sequence.gsub(/T/, 'U'))
  end

  def reverse_compliment
    @rev_compliment ||= build_reverse_compliment
  end

  private
  def build_reverse_compliment
    reversed = @sequence.reverse
    reversed.chars.each_with_index {|char, index| reversed[index] = @@compliments[char] }
    reversed
  end
end

class RNA < MacroMolecule
  @@symbols = @@symbols | ['U']
end
  

