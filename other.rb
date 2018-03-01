# ruboat hecc

require 'discordrb'
require_relative './constants.rb'

module Commands
    class Command
        attr_reader :name, :code, :permissions, :description
        def initialize(name, code, permissions, description)
            @name = name
            @code = code
            @permissions = permissions
            @description = description
        end

        def invoke(event, args)
            @code.call(event, args)
        end
        
        def perm_check(event)
            @permissions.all? {|p| event.author.permission?(p)}
        end
    end

    include Constants
    class Bot < Discordrb::Bot
        attr_reader :config, :prefixes, :commands # what the hell ruby
        def initialize(config:nil, token:nil, **kwargs)
            @config = config
            @commands = {}
            @prefixes = config['prefixes'].collect { |i| Regexp.new(i) }
            super(token: token, **kwargs)
            # begin command
            self.message do |ev|
                parsed = self.parse_prefix(ev.text)
                if !parsed.nil?
                    p parsed
                    msg = parsed[1]
                    sm = msg.split
                    cmd = sm[0]
                    sm.shift # i hope this doesn't die
                    puts cmd
                    p sm
                    if !@commands[cmd.to_sym].nil? # why
                        a = @commands[cmd.to_sym].invoke(ev, sm)
                        ev.respond(a)
                    end
                end
            end
        end

        def cmd(sym, permissions, description, &block)
            @commands[sym] = Commands::Command.new(sym, block, permissions, description)
        end

        def parse_prefix(m)
            @prefixes.map {|i| m.match(i)}.compact[0]
        end
    end
end

