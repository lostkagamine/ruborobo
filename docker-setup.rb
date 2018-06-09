require 'yaml'

puts 'ruborobo config generator mk9001'
puts 'by ry00001'

puts 'reading enviro variables and building config'
if !ENV['DOCKER']
    puts 'im not inside docker you heck'
    exit 1
end

config = {
    'token' => ENV['TOKEN'],
    'invokers' => ENV['INVOKERS'].split('/').map {|a| a.split(' ')},
    'owner' => ENV['OWNER'].split(' ').map {|a| a.to_i},
    'version' => 'Docker'
}

puts 'writing config'
File.open('/usr/src/ruborobo/config.yml', 'w') do |f|
    f.write config.to_yaml
end
puts 'all done'