
def seconds_to_wdhms(seconds)
	seconds_diff = seconds.to_i.abs
	
	weeks = seconds_diff / (60 * 60 * 24 * 7)
	seconds_diff -= weeks * (60 * 60 * 24 * 7)
	
	days = seconds_diff / (60 * 60 * 24)
	seconds_diff -= days * (60 * 60 * 24)
	
	hours = seconds_diff / (60 * 60)
	seconds_diff -= hours * (60 * 60)
	
	minutes = seconds_diff / 60
	seconds_diff -= minutes * 60
	
	seconds = seconds_diff
	
	[weeks, days, hours, minutes, seconds]
end

def get_trimmed_uptime()
	uptime = '%d Week, %d Day, %d Hour, %d Minute, %d Second' % seconds_to_wdhms(Time.now.to_i - $START_TIME.to_i)
	uptime = uptime.split(", ")
	uptime.delete_if do |i| i[0..1] == "0 " end
	uptime.map! do |i| ((i.split(" ")[0].to_i != 1) ? i + "s" : i) end
	uptime.join(", ")
end

$bot.command(:about) do |event, *args|
	"Uptime: #{get_trimmed_uptime()}.\n" + 
	"Loaded #{$UTIL_MODULES.size} utility module#{$UTIL_MODULES.size == 1 ? "" : "s"} and #{$FUNCTIONAL_MODULES.size} functional module#{$FUNCTIONAL_MODULES.size == 1 ? "" : "s"}.\n" + 
	"Running on #{RUBY_DESCRIPTION.capitalize}.\n" + 
	"Created by Virtuoel:\n" + 
	"https://github.com/Virtuoel/DiscordBot"
end
