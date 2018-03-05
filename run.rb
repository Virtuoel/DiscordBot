require "date"
require "json"
require "open-uri"
require "openssl"
require "uri"
require "discordrb"

class ::Hash # https://stackoverflow.com/a/30225093
	def deep_merge(second)
		merger = proc { |key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : Array === v1 && Array === v2 ? v1 | v2 : [:undefined, nil, :nil].include?(v2) ? v1 : v2 }
		self.merge(second.to_h, &merger)
	end
end

def add_modules(folder="modules")
	loaded = []
	
	modules = Dir.entries(folder).select {|d| !File.directory?("#{folder}/#{d}") && d.end_with?(".rb")}
	modules.each do |m|
		m = "#{folder}/#{m}"
		loaded_module = m.chomp(".rb").reverse.chomp("#{folder.split("/")[0]}/".reverse).reverse
		loaded << loaded_module unless(loaded_module.start_with?("hidden/") || loaded_module.include?("/hidden/"))
		require_relative "#{m}"
	end
	
	subfolders = Dir.entries(folder).select {|d| File.directory?("#{folder}/#{d}")}
	subfolders.delete("..")
	subfolders.delete(".")
	
	subfolders.each do |d|
		loaded |= add_modules("#{folder}/#{d}")
	end
	return loaded
end

$UTIL_MODULES = add_modules "util"

def load_settings(filename)
	JSONHelper.read_safe(filename)
end

def save_settings(settings, filename)
	File.open(filename, "w") do |f| f.write(JSONHelper.to_pretty(settings)) end
end

require_relative "bot_settings"
require_relative "bot_credentials"

$bot = Discordrb::Commands::CommandBot.new(
	prefix: $COMMAND_PREFIX, 
	command_doesnt_exist_message: '"%command%" is not a valid command.',
	token: $BOT_TOKEN, 
	client_id: $BOT_CLIENT_ID)

puts "This bot's invite URL is: \n\t#{$bot.invite_url}\nClick on it to invite it to your server.";puts

def init_user(id, health_max=100.0, attack=1.0, defence=0.0, speed=1.0, intelligence=100.0, luck=75.0)
	id_str = "#{id}"
	return false unless $settings["users"][id_str].nil?
	
	user_info = {}
	user_info["hand"] = nil
	user_info["inventory"] = []
	user_info["points"] = 0
	
	user_attributes = {}
	user_attributes["health_max"] = health_max
	user_attributes["health"] = health_max
	user_attributes["attack"] = attack
	user_attributes["defence"] = defence
	user_attributes["speed"] = speed
	user_attributes["intelligence"] = intelligence
	user_attributes["luck"] = luck
	
	user_info["attributes"] = user_attributes
	
	$settings["users"][id_str] = user_info
	return true
end

def is_owner(user)
	return user.id == $OWNER_ID
end

def is_admin(user)
	return is_owner(user) || $ADMIN_IDS.contains?(user.id)
end

$stop_handlers = [ ->() { save_settings($settings, $SETTINGS_FILENAME) } ]

trap "SIGINT" do
	$stop_handlers.each do |h|
		h[]
	end
	exit 130
end

def send_msg(event, msg, delete_user_message=false)
	msg = $bot.send_message(event.channel.id, msg)
	if(delete_user_message==true && !event.message.nil?)
		sleep(time)
		event.message.delete
	end
	return msg
end

$MSG_DECAY_TIME = 10
def send_temp_msg(event, msg, delete_user_message=false, time=$MSG_DECAY_TIME)
	$bot.send_temporary_message(event.channel.id, msg, time)
	if(delete_user_message==true && !event.message.nil?)
		sleep(time)
		event.message.delete
	end
end

def parse_mention(text, type)
	target = $bot.parse_mention(text.to_s)
	target ||= $bot.parse_mention("<@#{text}>")
	if(!target.nil? && target.kind_of?(type))
		return target
	end
	return nil
end

$bot.ready do |event|
	$bot.game=$default_game
end

$FUNCTIONAL_MODULES = add_modules

puts "Loaded #{$UTIL_MODULES.size} util modules. #{$UTIL_MODULES.to_s}";puts
puts "Loaded #{$FUNCTIONAL_MODULES.size} functional modules. #{$FUNCTIONAL_MODULES.to_s}";puts

$START_TIME = Time.now

$bot.run

$stop_handlers.each do |h|
	h[]
end


