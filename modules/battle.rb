
def battle(event, args)
	source = event.user
	if(args[0] == "accept")
		return "WIP (accept)"
	elsif(args[0] == "deny")
		return "WIP (deny)"
	elsif(args[0] == "block")
		return "WIP (block)"
	else
		target = $bot.parse_mention(args[0])
		if(!target)
			target = $bot.parse_mention("<@#{args[0]}>")
		end
		if(target && target.kind_of?(Discordrb::User))
			if(source.id == target.id)
				send_temp_msg(event, "You cannot battle yourself!", true)
				return
			end
			return "<#{source.name}> wants to battle <#{target.name}>!\n\tType \"~battle accept\" to begin.\n\tType \"~battle deny\" to cancel.\n\tType \"~battle block\" to ignore battle requests for 24 hours."
		end
	end
end

$bot.command(:battle, min_args: 0, max_args: 2, description: "WIP", usage: "battle") do |event, *args|
	battle(event, args)
end
