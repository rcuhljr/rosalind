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

  def transcribe
    RNA.new(@sequence.gsub(/T/, 'U'))
  end
end

class RNA < MacroMolecule
  @@symbols = @@symbols | ['U']
end
  

