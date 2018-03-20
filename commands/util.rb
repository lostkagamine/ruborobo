# Utility module for commandorobo
# Written by ry00001

module Commands
    module Utils
        def self.nodash(i)
            i.split('').reject {|j| j == '-'}.join('')
        end

        def self.consume_switch(str) # this function does not eat nintendo switches. do not try to feed it those.
            nextarg = nil
            parsed = false
            switches = {}
            ws = str.split(' ')
            ws.each_with_index do |k, i|
                parsed = false
                if k.start_with?('-') && k.length > 1
                    # oh heck a switch
                    if k[1] == '-'
                        # oh heck another switch
                        k = self.nodash(k)
                        switches[k.to_sym] = ws[i+1].nil? ? true : ws[i+1]
                    else
                        # no double-switch: interpret literally
                        k = self.nodash(k)
                        if k.length == 1
                            switches[k.to_sym] = ws[i+1].nil? ? true : ws[i+1]
                        else
                            k.chars.each do |l|
                                switches[l.to_sym] = true
                            end
                            switches
                        end
                    end
                end
            end
            return switches
        end

        def self.fish_xdm_login_hack_hack_hack_hack # I don't know why this is here but it is, enjoy
            'perry was here'
        end

        def self.remove_switch(str)
            parsed = []
            skip = false
            str.split(' ').each do |i|
                if skip
                    skip = false
                    next
                end
                if i.start_with?('-') && i.length > 1
                    if i[1] == '-'
                        skip = true
                        next
                    else
                        i = self.nodash(i)
                        if i.length == 1
                            skip = true
                            next
                        else
                            next
                        end
                    end
                else
                    parsed << i
                end
            end
            parsed
        end
    end
end