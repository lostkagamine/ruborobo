# Events

module Ruborobo
    $bot.evt(:command_error) do |ev, cmd, exception|
        ev.respond "#{['Apparently Ry or Erisa can\'t code.', 'Oof, ow, ouchie.', 'Whee, bugs.', 'Woah, a Ruby bug! Let\'s pester Erisa about it!', 'Oops, I died again. Thanks Ry.'].sample}\n```\n#{exception}```\n(Error in command #{cmd.name})"
    end

    $bot.evt(:command_notfound) {|ev, cmd|}

    $bot.evt(:command_noperms) do |ev, cmd, perm|
        owner = perm.perm.include? :bot_owner # haha yes
        if owner
            ev.respond "`#{ev.author.username} is not in the sudoers file. This incident will be reported.`"
            next
        end
        ev.respond "You do not have permission to perform this command. You need: `#{perm.prettify.join(', ')}`"
    end
end
