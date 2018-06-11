module Ruborobo
    $bot.cmd(:kick, perms:[:kick_members], desc:'Does a thing', invokers:[:remove, :eject]) do |ev, args|
        m = ev.bot.parse_mention(args.raw[0])
        begin
            on = m.on ev.server
        rescue
            'Bad user mention.'
        end
        ev.server.kick on
        'Success, user kicked.'
    end
end