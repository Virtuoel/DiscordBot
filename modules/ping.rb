
$bot.message(with_text: 'Ping!') do |event|
	m = event.respond('Pong!')
	m.edit "Pong! Time taken: #{Time.now - event.timestamp} seconds."
end
