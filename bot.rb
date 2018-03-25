# ruborobo - a ruby testing bot
# (C) 2018 Team ruborobo (ry00001, Erisa Arrowsmith (Seriel))

require 'discordrb' # meme
require 'json'
require 'commandorobo'
require 'rest_client'

config = JSON.parse(File.read('./config.json'))
bot = Commandorobo::Bot.new(config, config['token'])

puts "Project eRB v#{config['version']}"

bot.evt(:command_error) do |ev, cmd, exception|
    ev.respond "#{['Apparently Ry or Erisa can\'t code.', 'Oof, ow, ouchie.', 'Whee, bugs.', 'Woah, a Ruby bug! Let\'s pester Erisa about it!', 'Oops, I died again. Thanks Ry.'].sample}\n```\n#{exception}```\n(Error in command #{cmd.name})"
end

bot.evt(:command_notfound) {|ev, cmd| }#ev.respond('heck off')}

bot.evt(:command_noperms) do |ev, cmd, perm|
    ev.respond "You do not have permission to perform this command. You need: `#{perm.prettify.join(', ')}`"
end

bot.cmd(:ok, desc:'why') do |ev, args|
    ha = ['\*angry bot noises\*', 'henlo', 'why', 'y', 'no u', 'ok']
    ha.sample
end

bot.cmd(:die, perms:[:bot_owner], desc:'k', invokers:[:shut]) do |ev, args|
    ev.respond ['ok bye', 'good hecking bye', 'rip', '\*Drain gurgling\*', '\*groaning\*', '*dies*'].sample
    exit!
end

bot.cmd(:megasucc, desc:'succer', invokers:[:supersucc, :msucc]) do |ev, a|
    switcc = a.switches[:t] || a.switches[:times]
    if switcc == true
        switcc = 1
    end
    switcc = (switcc.to_i) || 1
    r = a.noswitch
    for m in 0..switcc do
        r = r.map {|d| d.split('').map(&:succ).join('')}
    end
    if r == '' || r.nil?
        ':warning: Pass arguments to this command.'
    else
        r.join(' ')
    end
end

bot.cmd(:succ, desc:'succ') do |ev, a|
    r = a.raw.map(&:succ).join(' ')
    if r == '' || r.nil?
        ':warning: Pass arguments to this command.'
    else
        r
    end
end

bot.cmd(:openryswhisker, perms:[:bot_owner], desc:'open ry\'s whisker menu', invokers:[:orwm]) do |ev, args|
    a = `xfce4-popup-whiskermenu`
    'ok done'
end

bot.cmd(:kick, perms:[:kick_members], desc:'Does a thing', invokers:[:remove]) do |ev, args|
    if args.raw[0].nil?
        ':warning: Provide a user mention.'
    end
    m = ev.bot.parse_mention(args.raw[0])
    if m.nil?
        ':warning: Invalid user mention.'
    end
    ev.server.kick m.on(ev.server)
    'Success, user kicked.'
end

bot.cmd(:setgame, desc:'it sets the game', invokers:[:sg]) do |ev, args|
    ev.bot.game = args.raw.join(' ')
    'k'
end

bot.cmd(:help, desc:'where you are') do |ev, args|
    s = '```'
    bot.commands.each do |v|
        next unless v.perm_check(ev)
        hasinv = v.invokers != [v.name]
        if hasinv
            currinv = " (#{v.invokers.map {|t| t.to_s}.join(', ')})"
        else
            currinv = ''
        end
        s << "#{v.name} - #{v.description.nil? ? '*No description given.*' : v.description}#{currinv}\n"
    end
    s << '```'
    s
end

bot.cmd(:error, perms:[:bot_owner], desc:'crashe') do |ev, args|
    3/0
end

bot.cmd(:eval, perms:[:bot_owner], desc:'lol', invokers:[:ev, :e]) do |ev, args|
    begin
        res = eval args.raw.join(' ')
        res = res.to_s
	    res = res.gsub(ev.bot.config['token'], '<no>')
        if res.length > 1984
            hbresp = RestClient.post('https://hastebin.com/documents', res)
            thing = eval hbresp.body
            ":warning: Output too long! (#{res.length} > 1984 characters) See the full output here: https://hastebin.com/raw/#{thing[:key]}"
        else
            res
        end
    rescue Exception => e
        "```\n#{e}```"
    end
end

bot.cmd(:echo, perms:[:bot_owner], desc:'it says what you say', invokers:[:say]) do |ev, args|
    args.raw.join(' ')
end

bot.cmd(:switchtest, desc:'it\'s a switch test', invokers:[:st]) do |ev, args|
    "```\nSwitches: #{args.switches}\nSwitch-less: #{args.noswitch}\n```"
end

bot.cmd(:scream, desc:'AAAAAAAAAAAAAAA', invokers:[:screm]) do |ev, args|
    switcc = args.switches[:t]
    if switcc == true
        switcc = 1
    end
    switcc = (switcc.to_i) || 0
    args.noswitch.join(' ').upcase + '!' * switcc
end

bot.ready do |ev|
    aa = bot.invokers.map {|x| x.value}
    puts "Bot ready, logged in as #{ev.bot.profile.distinct} (#{ev.bot.profile.id})"
    puts "Prefixes: #{aa}"
end

bot.run

