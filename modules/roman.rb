
def to_roman(number)
	if(number.to_i != number.to_f)
		return ""
	end
	number = number.to_i
	if(number < 0 || number > 3999) then
		return ""
	end
	if (number < 1) then return "" end
	if (number >= 1000) then return "M" + to_roman(number - 1000) end
	if (number >= 900) then return "CM" + to_roman(number - 900) end
	if (number >= 500) then return "D" + to_roman(number - 500) end
	if (number >= 400) then return "CD" + to_roman(number - 400) end
	if (number >= 100) then return "C" + to_roman(number - 100) end
	if (number >= 90) then return "XC" + to_roman(number - 90) end
	if (number >= 50) then return "L" + to_roman(number - 50) end
	if (number >= 40) then return "XL" + to_roman(number - 40) end
	if (number >= 10) then return "X" + to_roman(number - 10) end
	if (number >= 9) then return "IX" + to_roman(number - 9) end
	if (number >= 5) then return "V" + to_roman(number - 5) end
	if (number >= 4) then return "IV" + to_roman(number - 4) end
	if (number >= 1) then return "I" + to_roman(number - 1) end
end

$bot.command(:roman, min_args: 1, max_args: 1, description: "Convert the given number to Roman Numerals.", usage: "roman <number>") do |event, *args|
	msg = to_roman(args.join(""))
	msg = msg.strip.empty? ? "Input must be an integer between 1 and 3999." : msg
	msg
end
