
def exec_stop(event)
	return nil unless is_admin(event.user)
	send_temp_msg(event, "Goodbye.", true, 2)
	sleep(1)
	$bot.stop
end

$bot.command(:kill, help_available: false) do |event|
	exec_stop(event)
end

$bot.command(:stop, help_available: false) do |event|
	exec_stop(event)
end

$bot.command(:shutdown, help_available: false) do |event|
	exec_stop(event)
end
