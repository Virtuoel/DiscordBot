
def debug(event, args)
	return nil
end

$bot.command(:debug, help_available: false) do |event, *args|
	break unless is_admin(event.user)
	debug(event, args)
end
