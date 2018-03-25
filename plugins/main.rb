# Main plugin for ruborobo

module Ruborobo
    $bot.cmd(:help, desc:'where you are') do |ev, args|
        s = '```'
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
        s << '```'
        s
    end
end