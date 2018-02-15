
$settings["tags"] ||= {}

def handle_tag(event, args)
	$settings["tags"] ||= {}
	case args[0].downcase
	when "create"
		return "No tag supplied." if args[1].nil?
		return "Invalid tag name \"#{args[1]}\"." if !$settings["tags"][args[1]].nil? && $settings["tags"][args[1]]["owner"] == -1
		return "Tag \"#{args[1]}\" already exists." if !$settings["tags"][args[1]].nil?
		$settings["tags"][args[1]] = {"data" => args[2..-1].join(" "), "owner" => event.user.id, "creator" => event.user.id}
		return "Tag \"#{args[1]}\" created successfully."
	when "rename"
		return "No tag supplied." if args[1].nil?
		return "Invalid tag name \"#{args[1]}\"." if !$settings["tags"][args[1]].nil? && $settings["tags"][args[1]]["owner"] == -1
		return "Tag \"#{args[1]}\" already exists." if !$settings["tags"][args[1]].nil?
		return "You do not own the tag \"#{args[1]}\"." if $settings["tags"][args[1]]["owner"] != event.user.id && !is_admin(event.user)
		return "No new name supplied." if args[2].nil?
		$settings["tags"][args[1]] = {"data" => args[2..-1].join(" "), "owner" => event.user.id}
		return "Tag \"#{args[1]}\" renamed successfully."
	when "give"
		return "No tag supplied." if args[1].nil?
		return "Invalid tag name \"#{args[1]}\"." if !$settings["tags"][args[1]].nil? && $settings["tags"][args[1]]["owner"] == -1
		return "Tag \"#{args[1]}\" does not exist." if $settings["tags"][args[1]].nil?
		return "You do not own the tag \"#{args[1]}\"." if $settings["tags"][args[1]]["owner"] != event.user.id && !is_admin(event.user)
		return "No new owner supplied." if args[2].nil?
		new_owner = parse_mention(args[2..-1].join(" "), Discordrb::User)
		$settings["tags"][args[1]]["owner"] = new_owner.id
		return "Tag \"#{args[1]}\" transferred to #{new_owner.distinct} successfully."
	when "edit"
		return "No tag supplied." if args[1].nil?
		return "Invalid tag name \"#{args[1]}\"." if !$settings["tags"][args[1]].nil? && $settings["tags"][args[1]]["owner"] == -1
		return "Tag \"#{args[1]}\" does not exist." if $settings["tags"][args[1]].nil?
		return "You do not own the tag \"#{args[1]}\"." if $settings["tags"][args[1]]["owner"] != event.user.id && !is_admin(event.user)
		return "No new data supplied." if args[2].nil?
		$settings["tags"][args[1]]["data"] = args[2..-1].join(" ")
		return "Tag \"#{args[1]}\" edited successfully."
	when "delete"
		return "No tag supplied." if args[1].nil?
		return "Invalid tag name \"#{args[1]}\"." if !$settings["tags"][args[1]].nil? && $settings["tags"][args[1]]["owner"] == -1
		return "Tag \"#{args[1]}\" does not exist." if $settings["tags"][args[1]].nil?
		return "You do not own the tag \"#{args[1]}\"." if $settings["tags"][args[1]]["owner"] != event.user.id && !is_admin(event.user)
		$settings["tags"].delete (args[1])
		return "Tag \"#{args[1]}\" deleted successfully."
	when "list"
		tag_list = $settings["tags"].to_a.select{|t| t[1]["owner"] != -1}.map {|t| t[0]}
		return "No tags." if tag_list.empty?
		return "Tags: \"#{tag_list.join("\", \"")}\"."
	else
		if args[0].nil?
			$bot.simple_execute("tag #{args[0]}", event)
		else
			return "Tag \"#{args[0]}\" does not exist." if $settings["tags"][args[0]].nil?
			return "Tag \"#{args[0]}\" owned by #{parse_mention($settings["tags"][args[0]]["owner"], Discordrb::User).distinct}:\n#{$settings["tags"][args[0]]["data"]}"
		end
	end
end

$bot.command(:tag, min_args: 1, max_args: 3, description: "WIP", usage: "tag <create | edit | delete | rename | list | give | tag_name> [tag_name] [content | new_name | new_content | new_user]") do |event, *args|
	handle_tag(event, args)
end



