
def parse_dream(event)
	unless($dreaming)
		attached = event.message.attachments
		embedded = event.message.embeds
		if(event.message.to_s =~ /\A#{URI::regexp}\z/)
			$last_dream = event.message.to_s
			puts "Set dream to #{$last_dream}"
		elsif(attached && !attached.empty?)
			puts "Attachments detected"
			attached.each do |item|
				if(item.height)
					$last_dream = item.url
					puts "Set dream to #{$last_dream}"
					break
				end
			end
		elsif(embedded && !embedded.empty?)
			puts "Embeds detected"
			embedded.each do |item|
				if(item.type == :image)
					$last_dream = item.url
					puts "Set dream to #{$last_dream}"
					break
				end
			end
		end
	end
end

$bot.message do |event| parse_dream(event) end

$last_dream = nil
$dreaming = false
$last_dream_time = 0

DREAM_DELAY = 5 # delay between dreams for non-admin users in minutes
def dream(event)
	if $dreaming then return "Already dreaming." end
	curr_time = Time.now().to_i
	unless (curr_time - $last_dream_time > 60 * DREAM_DELAY) || is_admin(event.user) then return "May only dream every **#{DREAM_DELAY}** minutes." end
	unless $last_dream then return "No image to dream of has been posted." end
	file_url = $last_dream
	$last_dream_time = curr_time
	$dreaming = true
	
	$bot.update_status(:idle, "Dreaming", nil)
	send_temp_msg(event, "I will start dreaming.")
	
	puts("Starting dreaming.")
	begin
		upload_filename = ""
		system("cd dream;./dream.sh #{file_url}")
		File.open("./dream/counter.txt") do |f|
			upload_filename = "./dream/results/dream_" + f.read.strip + ".png"
		end
		puts("Uploading result...")
		File.open(upload_filename) do |f|
			$bot.send_file(event.channel.id, f)
		end
		puts("Result uploaded.")
	rescue StandardError => e
		$bot.update_status(:online, $default_game, nil)
		$last_dream = nil
		$dreaming = false
		$last_dream_time = 0
		
		puts("Dreaming failed:\n#{e.to_s}")
		return "Error occurred during dreaming."
	end
	
	$bot.update_status(:online, $default_game, nil)
	$last_dream = nil
	$dreaming = false
	
	elapsed_time = Time.now.to_i - $last_dream_time
	puts("Finished dreaming in ~#{elapsed_time} seconds.")
	"Finished dreaming in **~#{elapsed_time}** seconds."
end

$bot.command(:dream, description: "Shows a deep dream of the previously uploaded image.", usage: "dream") do |event| dream(event) end

$bot.command(:dreaminfo, help_available: false, description: "Show the number of dreams so far.", usage: "dreaminfo") do |event|
	msg = ""
	File.open("./dream/counter.txt"){|f| msg = f.read.strip + " dream attempts so far."}
	msg
end
