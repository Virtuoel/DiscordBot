class GemCheck
	def self.require_or_install(require_name, *gem_names)
		require require_name
	rescue LoadError
		gem_names = [require_name] if gem_names.empty?
		gem_names.each do |gem_name|
			begin
				Gem.install(gem_name, Gem::Requirement.default, {:user_install => true})
			rescue
				STDERR.puts "Error: Dependency \"#{gem_name}\" not met.\nPlease run \"gem install --user-install #{gem_name}\"."
				exit 1
			end
		end
		require require_name
	end
end
