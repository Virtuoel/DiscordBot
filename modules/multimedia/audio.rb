require_relative "voice"

$bot.command(:audio, min_args: 1, max_args: 3, description: "Play or stop playing an audio file.", usage: "audio <list|play|pause|resume|stop> [filename] [volume_multiplier]") do |event, *args|
	next "I am not in any voice channel." unless $voice_conn
	if(args[0] == "play")
		$voice_conn.stop_playing(false)
		`pkill -P #{Process.pid}`
		if(args.size > 1 && $settings["audio"].include?(args[1]))
			path = "./audio/"+args[1]+$settings["audio"][args[1]]
			audio_file = File.open(path)
			if(args.size > 2)
				begin
					multiplier = args[2].to_f
					if(multiplier < 0 || multiplier > 1)
						next "Volume multiplier must be between 0 and 1"
					else
						$voice_conn.filter_volume = multiplier
						$voice_conn_volume = multiplier
					end
				rescue
					next "Volume multiplier must be between 0 and 1"
				end
			end
			send_msg(event, "Playing #{args[1]} at volume #{$voice_conn_volume}")
			$voice_conn.play_io(audio_file)
		else
			next "Invalid audio file"
		end
	elsif(args[0] == "resume")
		$voice_conn.continue
	elsif(args[0] == "pause")
		$voice_conn.pause
	elsif(args[0] == "volume")
		begin
			multiplier = args[1].to_f
			if(multiplier <= 0)
				next "Volume multiplier must be greater than 0"
			else
				$voice_conn.volume = multiplier
				next "Set volume to #{$voice_conn_volume * multiplier}"
			end
		rescue
			next "Volume multiplier must be between 0 and 1"
		end
	elsif(args[0] == "stop")
		if($voice_conn.playing?)
			$voice_conn.stop_playing(true)
			$voice_conn_volume = 1.0
		end
	elsif(args[0] == "list")
		next $settings["audio"].keys.to_s
	end
	nil
end
