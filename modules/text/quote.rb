
$bot.command(:quote,  min_args: 1, description: "Quotes what you said.", usage: "quote <text>") do |event, *args|
	"\"" + args.join(" ") + "\"\n\t-" + event.user.distinct
end
