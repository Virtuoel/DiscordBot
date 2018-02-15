
$bot.command(:avatar, min_args: 0, description: "Get the URL of a user's avatar", usage: "avatar <username|mention|\"server\">") do |event, *args|
	ret = event.user.avatar_url
	if(args.length > 0)
		if(args[0] == "server")
			Discordrb::API.icon_url(event.channel.server.id, event.channel.server.icon_id)
		else
			user = parse_mention(args.join(" "), Discordrb::User)
			if(user)
				ret = user.avatar_url()
			else
				ret = nil
			end
		end
	end
	ret
end
