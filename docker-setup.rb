require 'yaml'

puts 'ruborobo config generator mk9001'
puts 'by ry00001'

puts 'reading enviro variables and building config'
if !ENV['DOCKER']
    puts 'im not inside docker you heck'
    exit 1
end

puts 'writing config'
File.open('/usr/src/ruborobo/config.yml', 'w') do |f|
    f.write config.to_yaml
end
puts 'all done'