
$bot.command(:eval, help_available: false) do |event, *args|
	break unless is_owner(event.user)
	
	begin
		eval args.join(' ')
	rescue => e
		event.user.pm("--------------\nAn error occurred:\n" + e.to_s)
	end
end
