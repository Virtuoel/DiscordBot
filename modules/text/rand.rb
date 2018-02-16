
$bot.command(:rand, min_args: 1, description: "Chooses from a list of options.", usage: "rand <option> [option]...") do |event, *args|
	"#{args[$rand.rand(args.size)]}\n\tFrom [ #{args.join(", ")} ]"
end
