module Ruborobo
    $bot.cmd(:kick, perms:[:kick_members], desc:'Does a thing', invokers:[:remove]) do |ev, args|
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
end