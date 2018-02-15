
MAX_WAIT = 120

$bot.command(:wait, min_args: 1, max_args: 2) do |event, *args|
	time = args[0].to_f rescue 0
	if time <= 0
		send_temp_msg(event, "Invalid duration \"#{args[0]}\"!", true)
		return
	end
	if !is_admin(event.user) && time > MAX_WAIT
		send_temp_msg(event, "You do not have permission to use the duration \"#{time}\"!", true)
		return
	end
	send_temp_msg(event, "Waiting for #{time} second#{time > 0 ? "s" : ""}...", false, time + MSG_DECAY_TIME)
	sleep(time)
	send_temp_msg(event, "Waited for #{time} second#{time > 0 ? "s" : ""}.", true)
end
