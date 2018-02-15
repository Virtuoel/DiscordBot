require "base64"
require "securerandom"

def gen_ppm_header(width, height)
	"P6\n#{width} #{height}\n255\n"
end

def gen_ppm_image(data, width, height)
	gen_ppm_header(width, height) + data
end

def write_ppm_image(filename, data, width, height)
	write_file(filename, gen_ppm_image(data, width, height))
end

def write_file(filename, data)
	File.open(filename, "w") do |f|
		f.write(data)
	end
	true
rescue
	false
end

def read_file(filename)
	File.open(filename, "r") do |f|
		return f.read
	end
rescue
	nil
end

def main()
	
	data_64 = read_file("uni.txt")
	data = Base64.decode64(data_64)
	write_file("uni.png", data)
	
	
	
	data_64 = SecureRandom.base64(128)
	data = Base64.decode64(data_64)
	
	resolution = data.bytesize / 3
	edge = Math.sqrt(resolution).to_i
	
	filename = "test.ppm"
	write_ppm_image(filename, data, edge, edge)
	
	`ppmtobmp -bpp=24 #{filename} | convert -format png - test.png`
	
	return
	
	path = "./assets/"
	filename = "#{path}/test.pam"
	
	data =
	[
		[255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255],
		[255,   0, 255,   0, 255,   0,   0,   0, 255, 255, 255, 255],
		[255,   0,   0,   0, 255, 255,   0, 255, 255, 255, 255, 255],
		[255,   0, 255,   0, 255,   0,   0,   0, 255, 255, 255, 255],
		[255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255]
	]
	
	write_pam_image(filename, data.flatten.compact.pack("C*"), :RGB_ALPHA, data[0].length/3, data.length)
end


$bot.command(:image) do |event, *args|
	break unless is_admin(event.user)
	debug(event, args)
end


$bot.command(:image, description: "Create a square image. Uses Netpgm .PPM format", usage: "image <base64>") do |event, *args|
	if args[0] == "web" && args[1]
		data_64 = open(args[1]).read.to_s
	else
		data_64 = args.join(" ").to_s
	end
	
	data = Base64.decode64(data_64)
	
	resolution = data.bytesize / 3
	edge = Math.sqrt(resolution).to_i
	
	filename = "test.ppm"
	write_ppm_image(filename, data, edge, edge)
	
	`ppmtobmp -bpp=24 #{filename} | convert -format png - test.png`
	File.open("test.png", "r") do |f|
		event.send_file(f)
	end
	`rm test.ppm`
	nil
end


