# Erio in Ruby
# by ry00001

require 'discordrb' # meme
require 'json'
require 'rest_client'
Dir["commands/*.rb"].each { |r|
    require_relative r
}
$config = JSON.parse(File.read('./config.json'))
$bot = Commands::Bot.new(config:$config, token:$config['token'])

puts "Project eRB v#{$config['version']}"

$bot.event(:command_error) do |ev, cmd, exception|
    ev.respond "#{['Apparently Ry or Erisa can\'t code.', 'Oof, ow, ouchie.', 'Whee, bugs.', 'Woah, a Ruby bug! Let\'s pester Erisa about it!', 'Oops, I died again. Thanks Ry.'].sample}\n```\n#{exception}```\n(Error in command #{cmd.name})"
end

$bot.event(:command_notfound) {|ev, cmd|}

$bot.event(:command_noperms) do |ev, cmd|
    things = [
        'No. (Invalid permissions.)',
        'You do not have permission to use this command.',
        'Nope... Not enough permissions.',
        'Heck off. (Invalid permissions.)'
    ]
    ev.respond things.sample
end

$bot.cmd(:ok, [], 'why') do |ev, args|
    ha = ['\*angry bot noises\*', 'henlo', 'why', 'y', 'no u', 'ok']
    ha.sample
end

$bot.cmd(:die, [:bot_owner], 'k', [:shut]) do |ev, args|
    ev.respond ['ok bye', 'good hecking bye', 'rip', '\*Drain gurgling\*', '\*groaning\*', '*dies*'].sample
    exit!
end

$bot.cmd(:succ, [], 'you know what this does') do |ev, a|
    r = a.map {|d| d.split('').map(&:succ).join('')}.join(' ')
    if r == '' || r.nil?
        ':warning: Pass arguments to this command.'
    else
        r
    end
end

$bot.cmd(:help, [], 'where you are') do |ev, args|
    s = ''
    $bot.commands.each do |v|
        next unless v.perm_check(ev)
        hasinv = v.invokers != [v.name]
        if hasinv
            currinv = " (#{v.invokers.map {|t| t.to_s}.join(', ')})"
        else
            currinv = ''
        end
        s << "#{v.name} - #{v.description.nil? ? '*No description given.*' : v.description}#{currinv}\n"
    end
    s
end

$bot.cmd(:error, [:bot_owner], 'crashe') do |ev, args|
    3/0
end

$bot.cmd(:eval, [:bot_owner], 'lol') do |ev, args|
    begin
        res = eval args.join(' ')
        res = res.to_s
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

$bot.ready do |ev|
    aa = $bot.prefixes
    puts "Bot ready, logged in as #{ev.bot.profile.distinct} (#{ev.bot.profile.id})"
    puts "Prefixes: #{aa}"
end

$bot.run

