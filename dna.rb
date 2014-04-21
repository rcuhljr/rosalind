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

  def gc_content
    @gc_content ||= (nucleotide_counts['G'] + nucleotide_counts['C']) / @sequence.length.to_f
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
    reversed = reversed.chars.map {|char| @@compliments[char] }.join()
  end
end

class RNA < MacroMolecule
  @@symbols = @@symbols | ['U']
  @@codon_map = {'UUU'=>'F', 'CUU'=>'L', 'AUU'=>'I', 'GUU'=>'V', 'UUC'=>'F', 'CUC'=>'L', 'AUC'=>'I', 'GUC'=>'V', 'UUA'=>'L', 'CUA'=>'L', 'AUA'=>'I', 'GUA'=>'V', 'UUG'=>'L', 'CUG'=>'L', 'AUG'=>'M', 'GUG'=>'V', 'UCU'=>'S', 'CCU'=>'P', 'ACU'=>'T', 'GCU'=>'A', 'UCC'=>'S', 'CCC'=>'P', 'ACC'=>'T', 'GCC'=>'A', 'UCA'=>'S', 'CCA'=>'P', 'ACA'=>'T', 'GCA'=>'A', 'UCG'=>'S', 'CCG'=>'P', 'ACG'=>'T', 'GCG'=>'A', 'UAU'=>'Y', 'CAU'=>'H', 'AAU'=>'N', 'GAU'=>'D', 'UAC'=>'Y', 'CAC'=>'H', 'AAC'=>'N', 'GAC'=>'D', 'UAA'=>nil, 'CAA'=>'Q', 'AAA'=>'K', 'GAA'=>'E', 'UAG'=>nil, 'CAG'=>'Q', 'AAG'=>'K', 'GAG'=>'E', 'UGU'=>'C', 'CGU'=>'R', 'AGU'=>'S', 'GGU'=>'G', 'UGC'=>'C', 'CGC'=>'R', 'AGC'=>'S', 'GGC'=>'G', 'UGA'=>nil, 'CGA'=>'R', 'AGA'=>'R', 'GGA'=>'G', 'UGG'=>'W', 'CGG'=>'R', 'AGG'=>'R', 'GGG'=>'G'}
  @@protein_counts = {"F"=>2, "L"=>6, "I"=>3, "V"=>4, "M"=>1, "S"=>6, "P"=>4, "T"=>4, "A"=>4, "Y"=>2, "H"=>2, "N"=>2, "D"=>2, "Q"=>2, "K"=>2, "E"=>2, "C"=>2, "R"=>6, "G"=>4, "W"=>1}

  def encode_protein      
    @sequence.scan(/.{3}/).map{|item| @@codon_map[item]}.join()
  end

  def self.possible_rna_mod protein, modulo
    counts = protein.chars.map{|prot| @@protein_counts[prot]}
    #Stop codons
    counts << 3
    counts.inject(1) {|sum, count| (sum*count)%modulo}
  end
end
  

