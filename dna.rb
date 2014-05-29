require 'set'

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

  def self.hamming_distance(seqA, seqB)
    MacroMolecule.pair_nucleotides(seqA,seqB).select {|pair| mutation?(pair) }.length
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

  def self.longest_common_substring sequence_collection    
    aSet = Set.new()
    seq = sequence_collection.first
    (0..seq.size).each{|x| (x..seq.size).each{ |y| aSet.add seq[x..y] }}                  
    aSet.sort{|x,y| y.size <=> x.size}.each do |subs|               
      index = 0      
      while sequence_collection[index] =~ /#{subs}/
        index += 1
      end
      return subs if index == sequence_collection.size
    end
    ""
  end

  private
  def dna_count     
    @@symbols.each_with_object({}) {|acid, counts| counts[acid] = count acid }    
  end

  def paired_nucleotides other_sequence
    MacroMolecule.pair_nucleotides(@sequence, other_sequence)    
  end

  def self.pair_nucleotides(seqA, seqB)
    seqB.chars.zip(seqA.chars).take_while {|pair| !pair.include?(nil) }
  end

  def self.mutation? pair
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
  @@trans_trans_map = Hash.new(false) 
  @@trans_trans_map[["A","G"]] = true
  @@trans_trans_map[["G","A"]] = true
  @@trans_trans_map[["C","T"]] = true
  @@trans_trans_map[["T","C"]] = true



  def transcribe
    RNA.new(@sequence.gsub(/T/, 'U'))
  end

  def reverse_compliment
    @rev_compliment ||= build_reverse_compliment
  end

  def self.reverse_compliment sequence
    DNA.build_reverse_compliment sequence
  end

  def reverese_transcribe
    RNA.new(reverse_compliment.gsub(/T/, 'U'))
  end

  def reverse_palindromes
    palindromes = []
    (4..12).each do |length|
      (0..@sequence.size-(length)).each do |offset|
        palindromes << [offset+1, length] if @sequence[offset..(offset+length-1)] == reverse_compliment[(-1*offset-length)..(-1*offset-1)]
      end
    end
    palindromes
  end

  def transition_tranversion_ratio other_sequence
    transitions, transversions = [0,0]
    @sequence.chars.zip(other_sequence.chars).map do |pair|
      next if pair[0] == pair[1]
      if @@trans_trans_map[pair]
        transitions += 1
      else
        transversions += 1
      end
    end
    transitions.to_f/transversions
  end

  private
  def build_reverse_compliment
    reversed = @sequence.reverse
    reversed = reversed.chars.map {|char| @@compliments[char] }.join()
  end

  def self.build_reverse_compliment sequence
    sequence.reverse.chars.map {|char| @@compliments[char] }.join()
  end
end

class RNA < MacroMolecule
  @@symbols = @@symbols | ['U']
  @@codon_map = {'UUU'=>'F', 'CUU'=>'L', 'AUU'=>'I', 'GUU'=>'V', 'UUC'=>'F', 'CUC'=>'L', 'AUC'=>'I', 'GUC'=>'V', 'UUA'=>'L', 'CUA'=>'L', 'AUA'=>'I', 'GUA'=>'V', 'UUG'=>'L', 'CUG'=>'L', 'AUG'=>'M', 'GUG'=>'V', 'UCU'=>'S', 'CCU'=>'P', 'ACU'=>'T', 'GCU'=>'A', 'UCC'=>'S', 'CCC'=>'P', 'ACC'=>'T', 'GCC'=>'A', 'UCA'=>'S', 'CCA'=>'P', 'ACA'=>'T', 'GCA'=>'A', 'UCG'=>'S', 'CCG'=>'P', 'ACG'=>'T', 'GCG'=>'A', 'UAU'=>'Y', 'CAU'=>'H', 'AAU'=>'N', 'GAU'=>'D', 'UAC'=>'Y', 'CAC'=>'H', 'AAC'=>'N', 'GAC'=>'D', 'UAA'=>nil, 'CAA'=>'Q', 'AAA'=>'K', 'GAA'=>'E', 'UAG'=>nil, 'CAG'=>'Q', 'AAG'=>'K', 'GAG'=>'E', 'UGU'=>'C', 'CGU'=>'R', 'AGU'=>'S', 'GGU'=>'G', 'UGC'=>'C', 'CGC'=>'R', 'AGC'=>'S', 'GGC'=>'G', 'UGA'=>nil, 'CGA'=>'R', 'AGA'=>'R', 'GGA'=>'G', 'UGG'=>'W', 'CGG'=>'R', 'AGG'=>'R', 'GGG'=>'G'}
  @@protein_counts = {"F"=>2, "L"=>6, "I"=>3, "V"=>4, "M"=>1, "S"=>6, "P"=>4, "T"=>4, "A"=>4, "Y"=>2, "H"=>2, "N"=>2, "D"=>2, "Q"=>2, "K"=>2, "E"=>2, "C"=>2, "R"=>6, "G"=>4, "W"=>1}
  @@protein_weights = {'A'=>71.03711,'C'=>103.00919,'D'=>115.02694,'E'=>129.04259,'F'=>147.06841,'G'=>57.02146,'H'=>137.05891,'I'=>113.08406,'K'=>128.09496,'L'=>113.08406,'M'=>131.04049,'N'=>114.04293,'P'=>97.05276,'Q'=>128.05858,'R'=>156.10111,'S'=>87.03203,'T'=>101.04768,'V'=>99.06841,'W'=>186.07931,'Y'=>163.06333};
  @@folding_matches = {'A'=> 'U', 'U'=> 'A', 'C'=>'G', 'G'=> 'C'}  

  def encode_protein      
    @sequence.scan(/.{3}/).map{|item| @@codon_map[item]}.join()
  end

  def candidate_proteins
    collect_orfs.map{|orf| orf.map{|codon| @@codon_map[codon]}.join }
  end

  def self.possible_rna_mod protein, modulo
    counts = protein.chars.map{|prot| @@protein_counts[prot]}
    #Stop codons
    counts << 3
    counts.inject(1) {|sum, count| (sum*count)%modulo}
  end

  def self.protein_weight protein_string
    protein_string.chars.inject(0) { |weight, protein| weight + @@protein_weights[protein]}
  end

  def perfect_matches    
    indexes_au = (0..@sequence.gsub(/[AU]/,'').length-1).to_a
    indexes_gc = (0..@sequence.gsub(/[GC]/,'').length-1).to_a    
    (indexes_au.length/2).downto(1).inject(:*) * (indexes_gc.length/2).downto(1).inject(:*)
  end

  private
  
  def collect_orfs
    valid_reads = []
    offset_codons = [@sequence.scan(/.{3}/), @sequence[1..-1].scan(/.{3}/), @sequence[2..-1].scan(/.{3}/)]
    offset_codons.each do |codon_set| 
      get_valid_pairs(codon_set).each do |pair|
        valid_reads << codon_set[pair[0]..(pair[1]-1)]
      end
    end
    valid_reads
  end

  def get_valid_pairs codon_set
      starts = codon_set.each_index.select {|i| codon_set[i] == 'AUG'}
      stops = codon_set.each_index.select {|i| codon_set[i] =~ /UAA|UAG|UGA/}      
      starts.map{ |start| [start, stops.select{ |stop| stop > start }.min] }.select{ |_,y| y }
  end
end
  

