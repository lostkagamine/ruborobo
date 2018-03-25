# ruborobo - a ruby testing bot
# (C) 2018 Team ruborobo (ry00001, Erisa Arrowsmith (Seriel))

module Ruborobo
    require 'discordrb' # meme
    require 'json'
    require 'commandorobo'
    require 'rest_client'

    config = JSON.parse(File.read('./config.json'))
    $bot = Commandorobo::Bot.new(config, config['token'])

    puts "Project eRB v#{config['version']}"

    Dir['plugins/**/*.rb'].each do |p|
        puts "Loading #{File.basename(p, '.rb')}..."
        require_relative p
    end

    $bot.ready do |ev|
        aa = $bot.invokers.map {|x| x.value}
        puts "Bot ready, logged in as #{ev.bot.profile.distinct} (#{ev.bot.profile.id})"
        puts "Prefixes: #{aa}"
    end

    $bot.run
end