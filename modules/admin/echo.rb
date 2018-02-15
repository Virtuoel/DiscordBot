
$bot.command(:echo, help_available: false,  min_args: 1, description: "Repeats what you said.", usage: "echo <text>") do |event, *args|
	return "You do not have permission to use this command." unless is_admin(event.user)
	event.message.delete
	args.join(" ")
end
