require "json"

class JSONHelper
	def self.read_safe(filename, default={})
		begin
			return JSON.parse(File.read(filename))
		rescue StandardError => e
			puts e
			return default
		end
	end
	
	def self.to_pretty(json_data)
		lines = JSON.pretty_generate(json_data).gsub(/(?:^|\G) {2}/m,"\t").split("\n")
		done = ""
		lines.each do |line|
			if(line.end_with?(": {")) then
				tabs = line[/\A\t+/].size
				line.gsub!(": {", ":\n#{"\t" * tabs}{")
			end
			if(line.end_with?(": [")) then
				tabs = line[/\A\t+/].size
				line.gsub!(": [", ":\n#{"\t" * tabs}[")
			end
			done += line + "\n"
		end
		return done
	end
end
