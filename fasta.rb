class FASTA
  def load_file file_name
		@data = {}
		@current_id = ""
		File.foreach(file_name) do |line|
			process_line line.chomp
		end
		@data
	end

	def process_line line
		if line =~ /^>(.*)/ then
			@current_id = $1
			@data[@current_id] = ""
		else
			@data[@current_id] << line
		end
	end
end