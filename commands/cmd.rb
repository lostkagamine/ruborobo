# ruboat hecc

require 'discordrb'
require_relative './constants.rb'

module Commands
    class NoPermission
        attr_reader :perm
        def initialize(perm)
            @perm = perm
        end

        def prettify # OH GOD PLEASE HELP ME
            @perm.map do |t| # <hackiness>
                t.to_s.split(/ /).map(&:capitalize).join(' ')
            end # </hackiness>
        end
    end

    class Command
        attr_reader :name, :code, :permissions, :description, :invokers
        def initialize(name, code, permissions, description, invokers, bot)
            @name = name
            @code = code
            @permissions = permissions
            @description = description
            @invokers = invokers.nil? ? [name] : invokers
	        @bot = bot
        end

        def invoke(event, args)
            @code.call(event, args)
        end
        
        def perm_check(event)
	        perms = {}
            @permissions.each do |p|
                if p == :bot_owner
                    perms[p] = @bot.config['owner'].include?(event.author.id)
                else
                    perms[p] = event.author.permission?(p)
                end
            end
            if !perms.values.all?
                noperms = []
                perms.keys.each do |p|
                    if !perms[p]
                        noperms << p
                    end
                end
                Commands::NoPermission(noperms)
            else
                true
            end
        end
    end

    include Constants
    class Bot < Discordrb::Bot
	    attr_accessor :prefixes
        attr_reader :config, :commands, :listeners # what the hell ruby
        def initialize(config:nil, token:nil, **kwargs)
                @config = config
                @commands = []
                @listeners = {}
                @prefixes = config['prefixes'].collect { |i| Regexp.new(i) }
                super(token: token, **kwargs)
                # begin command
                self.message do |ev|
                    parsed = self.parse_prefix(ev.text)
                    if !parsed.nil?
                    msg = parsed.to_s
                    sm = msg.split
                    cmd = parsed.captures[0].split[0]
                    sm.shift # i hope this doesn't die
                    acmd = self.get_command cmd.to_sym
                    if acmd.nil?
                        self.idispatch(:command_notfound, ev, cmd)
                    else
                        pc = acmd.perm_check(ev)
                        if pc.is_a?(Commands::NoPermission)
                            self.idispatch(:command_noperms, ev, acmd, pc)
                            next
                        end
                        begin
                            a = acmd.invoke(ev, sm)
                            ev.respond(a)
                        rescue Exception => err
                            self.idispatch(:command_error, ev, acmd, err)
                        end
                    end
                end
            end
        end

        def get_command(name)
            @commands.select {|c| c.invokers.include? name}.compact[0]
        end

        def event(name, &block)
            if name.is_a? String
                name = name.to_sym
            end
            if @listeners[name].nil?
                @listeners[name] = []
            end
            @listeners[name] << block
        end

        def idispatch(name, *args)
            if name.is_a? String
                name = name.to_sym
            end
            thing = @listeners[name]
            if thing.nil?
                raise "No event hooks registered for #{name.to_s}"
            else
                thing.each do |func|
                    func.call(*args)
                end
            end
        end

        def cmd(sym, perms:[], desc:nil, invokers:[], &block)
            invokers << sym
            @commands << Commands::Command.new(sym, block, perms, desc, invokers, self)
        end

        def parse_prefix(m)
            @prefixes.map {|i| m.match(i)}.compact[0]
        end
    end
end

