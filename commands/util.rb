# Switch parser for Commandorobo
# Written by ry00001

module Commands
    module Utils
        class SwitchResult
            def initialize(s, ns)
                @switch = s
                @noswitch = ns
            end
        end

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
                        end
                    end
                end
            end
            return switches
        end
    end
end