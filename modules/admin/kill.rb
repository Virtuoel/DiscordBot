
$bot.command(:kill, help_available: false) do |event|
	break unless is_admin(event.user)
	send_temp_msg(event, "Goodbye.", true, 2)
	sleep(1)
	on_stop()
	exit
end
