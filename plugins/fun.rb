module Ruborobo
    $bot.cmd(:megasucc, desc:'succer', invokers:[:supersucc, :msucc]) do |ev, a|
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
    
    $bot.cmd(:succ, desc:'succ') do |ev, a|
        r = a.raw.map(&:succ).join(' ')
        if r == '' || r.nil?
            ':warning: Pass arguments to this command.'
        else
            r
        end
    end

    $bot.cmd(:scream, desc:'AAAAAAAAAAAAAAA', invokers:[:screm]) do |ev, args|
        switcc = args.switches[:t]
        if switcc == true
            switcc = 1
        end
        switcc = (switcc.to_i) || 0
        args.noswitch.join(' ').upcase + '!' * switcc
    end

    $bot.cmd(:setgame, desc:'it sets the game', invokers:[:sg]) do |ev, args|
        ev.bot.game = args.raw.join(' ')
        'k'
    end
end