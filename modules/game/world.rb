
def load_template()
	$template = JSONHelper.read_safe(__FILE__.split("/")[0..-2].join("/") + "/" + "world_template.json")
end

def load_worlds()
	$worlds = JSONHelper.read_safe(__FILE__.split("/")[0..-2].join("/") + "/" + "worlds.json")
end

load_template
load_worlds

$stop_handlers.unshift ->() do
	File.open(__FILE__.split("/")[0..-2].join("/") + "/" + "worlds.json", "w") do |f|
		f.write(JSONHelper.to_pretty($worlds))
	end
# 	File.open(__FILE__.split("/")[0..-2].join("/") + "/" + "world_template.json", "w") do |f|
# 		f.write(JSONHelper.to_pretty($template))
# 	end
end

def getPlayerAvatar(player)
	getPlayerWorld(player)["player"]
end

def getPlayerWorld(player)
	$worlds[player.id.to_s]
end

def getLocation(player, location)
	getPlayerWorld(player)["areas"][location]
end

def getBorderLocation(player, location, direction)
	getLocation(player, location, direction)
end

def getPlayerLocation(player)
	getLocation(player, getPlayerLocationName(player))
end

def getPlayerLocationName(player)
	getPlayerAvatar(player)["pos"]
end

def validDir?(dir)
	case dir.downcase
	when "up", "down", "north", "south", "east", "west"
		true
	else
		false
	end
end

def getOppositeDirection(dir)
	return nil unless validDir?(dir)
	case dir.downcase
	when "up"
		"down"
	when "down"
		"up"
	when "north"
		"south"
	when "south"
		"north"
	when "east"
		"west"
	when "west"
		"east"
	end
end

def getFromDirectionMessage(dir)
	return "from somewhere" unless validDir?(dir)
	case dir.downcase
	when "up"
		"from above"
	when "down"
		"from below"
	else
		"from the #{dir}"
	end
end

def getToDirectionMessage(dir)
	return "in some strange direction" unless validDir?(dir)
	case dir.downcase
	when "up"
		"above you"
	when "down"
		"below you"
	else
		"to the #{dir}"
	end
end

def parse_action(event, args)
	player = event.user
	arg_count = args.size - 1
	action = args[0]
	args = args[1..-1]
	args ||= []
	action ||= ""
	case action.downcase
	when "generate", "gen", "create", "build", "make"
		return "Too many arguments supplied: (#{arg_count})" if arg_count > 0
		return "You already have a world generated." unless getPlayerWorld(player).nil?
		$worlds[player.id.to_s] = generate_world(player) if getPlayerWorld(player).nil?
		return "World generated.\n\n" + parse_action(event, ["inspect"])
	when "delete", "destroy", "remove"
		return "You do not have a world generated." if getPlayerWorld(player).nil?
		$worlds[player.id.to_s] = nil
		return "World deleted."
	when "regenerate", "regen", "recreate", "rebuild", "remake"
		return "Too many arguments supplied: (#{arg_count})" if arg_count > 1
		return "Too many arguments supplied: (#{arg_count})" if arg_count > 0 && args[0].downcase != "confirm"
		if arg_count > 0 && args[0].downcase == "confirm" then
			$worlds[player.id.to_s] = generate_world(player)
			return "World regenerated.\n\n" + parse_action(event, ["inspect"])
		else
			return "Run **`#{$COMMAND_PREFIX}world #{action} confirm`** to regenerate your world."
		end
	when "inspect", "check", "look"
		return "No world generated." if getPlayerWorld(player).nil?
		return "Too many arguments supplied: (#{arg_count})" if arg_count > 0
		msg = getPlayerLocation(player)["description"].sample
		borders = getPlayerLocation(player)["border"]
		borders.each_key do |dir|
			unless borders[dir].nil?
				msg += "\n" + getLocation(player, borders[dir])["far_description"].sample.gsub("@TO_DIRECTION@", getToDirectionMessage(dir)).capitalize
			end
		end
		return msg
	when "north", "south", "east", "west", "up", "down"
		return parse_action(event, ["go", action] + args)
	when "go", "move", "travel"
		return "No world generated." if getPlayerWorld(player).nil?
		return "Too many arguments supplied: (#{arg_count})" if arg_count > 1
		return "Too few arguments supplied: (#{arg_count})" if arg_count < 1
		direction = args[0]
		if validDir?(direction) then
			location = getPlayerLocation(player)
			destination_name = location["border"][direction]
			destination = getLocation(player, destination_name)
			if destination then
				exit_path = location["exit"][direction]
				exit_path ||= {"valid" => true}
				if exit_path["valid"] then
					enter_path = destination["enter"][direction]
					enter_path ||= {"valid" => true}
					if enter_path["valid"] then
						$worlds[player.id.to_s]["player"]["pos"] = destination_name
						msg = ""
						msg += exit_path["message"].sample + "\n" if exit_path["message"]
						msg += enter_path["message"].sample + "\n" if enter_path["message"]
						msg += parse_action(event, ["inspect"])
						return msg
					elsif enter_path["message"]
						return enter_path["message"].sample.gsub("@DESTINATION@", destination_name).gsub("@FROM_DIRECTION@", getFromDirectionMessage(direction)).gsub("@TO_DIRECTION@", getToDirectionMessage(direction)).gsub("@DIRECTION@", direction).capitalize
					else
						return "You are unable to reach the #{destination_name} #{getFromDirectionMessage(direction)}."
					end
				elsif exit_path["message"]
					return exit_path["message"].sample.gsub("@DESTINATION@", destination_name).gsub("@FROM_DIRECTION@", getFromDirectionMessage(direction)).gsub("@TO_DIRECTION@", getToDirectionMessage(direction)).gsub("@DIRECTION@", direction).capitalize
				else
					return "You are unable to leave the #{getPlayerLocationName(player) || "place"} #{getFromDirectionMessage(direction)}."
				end
			else
				return "There is nowhere to go #{getToDirectionMessage(direction)}."
			end
		else
			return "\"#{direction}\" is not a valid direction!"
		end
	else
		if getPlayerWorld(player).nil? then
			return "Run **`#{$COMMAND_PREFIX}world generate`** to create a new world."
		end
		return "Run **`#{$COMMAND_PREFIX}world <ACTION>`** to do an action. Try **`look`** to look around or **`go`** to move.\n" +
		       "Run **`#{$COMMAND_PREFIX}world delete`** to delete your world.\n" +
		       "Run **`#{$COMMAND_PREFIX}world regenerate`** to replace your world with a brand new one.\n"
	end
	nil
end

def generate_world(player)
	load_template
end

$bot.command(:world, description: "Adventure in a text world!", usage: "world [actions]...") do |event, *args|
	parse_action(event, args)
end
