
$bot.command(:prune, help_available: false) do |event, *args|
	break unless is_admin(event.user)
	amount = 0
	begin
		amount = args[0].to_i rescue 0
		if(amount <= 0)
			raise(ArgumentError)
		end
	rescue ArgumentError
		send_temp_msg(event, "Invalid quantity.", true)
	else
		event.channel.prune(amount+1)
		send_temp_msg(event, "Pruned #{amount} message#{amount > 0 ? "s" : ""}.")
	end
	nil
end
