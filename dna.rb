class MacroMolecule
  @@symbols = ['A', 'G', 'C']    

  def initialize sequence
    validate_dna sequence

    @sequence = sequence    
  end

  def count nucleotide
    validate_nucleotide nucleotide

    @sequence.count(nucleotide)
  end

  def nucleotide_counts
    @dna_count ||= dna_count
  end

  def hamming_distance other_sequence
    validate_dna other_sequence

    paired_nucleotides(other_sequence).select {|pair| mutation?(pair) }.length
  end

  def motif_locations sub_sequence
    validate_dna sub_sequence
    result = []
    i = -1
    while i = @sequence.index(sub_sequence, i+1) do 
      result << i+1
    end
    result
  end

  def to_s
    @sequence
  end

  private
  def dna_count     
    @@symbols.each_with_object({}) {|acid, counts| counts[acid] = count acid }    
  end

  def paired_nucleotides other_sequence
    other_sequence.chars.zip(@sequence.chars).take_while {|pair| !pair.include?(nil) }
  end

  def mutation? pair
    pair[0] != pair[1]
  end

  def validate_nucleotide nucleotide
    raise ArgumentError.new "Unrecognized Nucleotide: #{nucleotide}" unless @@symbols.include? nucleotide
  end

  def validate_dna sequence
    raise ArgumentError.new "Sequence contains non DNA symbols. #{sequence.gsub(/[#{@@symbols.join}]/,'')}" if illegal_characters? sequence
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
  

