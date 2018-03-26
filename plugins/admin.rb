module Ruborobo
    $bot.cmd(:error, perms:[:bot_owner], desc:'crashe') do |ev, args|
        3/0
    end

    $bot.cmd(:die, perms:[:bot_owner], desc:'restarts', invokers:[:shut]) do |ev, args|
        ev.respond ['ok bye', 'good hecking bye', 'rip', '\*Drain gurgling\*', '\*groaning\*', '*dies*'].sample
        exit!
    end

    $bot.cmd(:eval, perms:[:bot_owner], desc:'runs ruby code', invokers:[:ev, :e]) do |ev, args|
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

    $bot.cmd(:shell, perms:[:bot_owner], desc:'runs a shell command', invokers:[:sh]) do |ev, args|
        begin
            r = `#{args.raw.join(' ')}`
            if r.length > 1984
                hbresp = RestClient.post('https://hastebin.com/documents', r)
                thing = eval hbresp.body
                ":warning: Output too long! (#{r.length} > 1984 characters) See the full output here: https://hastebin.com/raw/#{thing[:key]}"
            else
                "```#{r}```"
            end
        rescue Exception => e
            "```\n#{e}```"
        end
    end

    $bot.cmd(:echo, perms:[:bot_owner], desc:'it says what you say', invokers:[:say]) do |ev, args|
        args.raw.join(' ')
    end
end