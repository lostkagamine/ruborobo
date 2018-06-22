# ruborobo - a ruby testing bot
# (C) 2018 Team ruborobo (ry00001, Erisa Arrowsmith (Seriel))

module Ruborobo
    require 'discordrb' # meme
    require 'json'
    require 'yaml'
    require 'commandorobo'
    require 'rest_client'

    config = {} # because scoping:tm:
    owners = nil

    if !ENV['DOCKER']
        is_yml = File.file? './config.yml'
        is_json = File.file? './config.json'
        if is_yml
            config = YAML.load(File.read('./config.yml'))
        elsif is_json
            puts 'Warning! JSON configuration files are deprecated and will be eventually removed! Migrate to YML as soon as possible!'
            config = JSON.parse(File.read('./config.json'))
        else
            puts "No config found - exiting...\nRefer to CONFIGURING.md for info."
            exit
        end
    else
        puts 'Docker detected, loading config from environment variables.'
        config = {
            'token' => ENV['TOKEN'],
            'invokers' => ENV['INVOKERS'].split('/').map {|a| a.split(' ')},
            'version' => '-Docker'
        }
        owners = ENV['OWNER'].split(',').map(&:to_i)
    end

    $bot = Commandorobo::Bot.new(config, config['token'], owners: owners) # oh it's colon not equal lol go me

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
