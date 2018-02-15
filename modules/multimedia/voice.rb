
$voice_conn = nil
$voice_conn_volume = 1.0
$voice_conn_name = nil

$bot.command(:connect, description: "Connect to the voice channel of the executor.") do |event|
	channel = event.user.voice_channel
	
	unless channel then
		send_temp_msg(event, "You are not in any voice channel.", true)
		return nil
	end
	
	$voice_conn = $bot.voice_connect(channel)
	$voice_conn_name = channel.name
	send_temp_msg(event, "Connected to voice channel: \"#{channel.name}\"", true)
end

$bot.command(:disconnect, description: "Disconnect from the connected voice channel.") do |event|
	next "I am not in any voice channel." unless $voice_conn
	
	msg = "Disconnected from voice channel: \"#{$voice_conn_name}\""
	
	$voice_conn.destroy
	$voice_conn = nil
	$voice_conn_name = nil
	send_temp_msg(event, msg, true)
end

$stop_handlers.unshift ->() do
	if(!$voice_conn.nil?)
		$voice_conn.stop_playing
		$voice_conn.speaking = false
		$voice_conn.destroy
		sleep(1)
	end
end
