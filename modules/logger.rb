
def log_chat(event)
	term_cols = `/usr/bin/env tput cols`.to_i rescue 80
	header = "[#{event.channel.name} @ #{event.channel.server.name}]<#{event.user.distinct}>: "
	print (header)
	lines = event.message.to_s.split("\n")
	if(!lines.empty?)
		first_line = lines[0].scan(/.{1,#{term_cols - header.length}}/)
		puts(first_line[0])
		(1...first_line.length).each do |str_1|
			print(" " * header.length)
			puts(first_line[str_1])
		end
		(1...lines.length).each do |i|
			lines[i].scan(/.{1,#{term_cols - header.length}}/).each do |str|
				print(" " * header.length)
				puts(str)
			end
		end
	end
end

$bot.message do |event| log_chat(event) end


