
def parse_soon(event)
	msg = event.message.to_s.downcase
	if(msg.include?("soon™") || msg.include?("soon^tm"))
		event.respond('https://i.imgur.com/6o1MuCy.png')
	end
	nil
end

$bot.message do |event| parse_soon(event) end
