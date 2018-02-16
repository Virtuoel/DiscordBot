
$bot.command(:unicode, min_args: 1, description: "Convert a hex number into the corresponding unicode character.", usage: "unicode <hex> [hex]...") do |event, *args|
	msg = ""
	args.each do |arg|
		msg = (msg + (''<<(arg.hex)))
	end
	"[ 0x#{args.join(", 0x")} ]:\n#{msg}"
end
