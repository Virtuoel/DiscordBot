
$bot.command(:reverse,  min_args: 1, description: "Reverses what you said.", usage: "quote <text>") do |event, *args|
	"\"" + args.join(' ').reverse + "\"\n\t-" + event.user.distinct
end
