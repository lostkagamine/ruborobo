a = {:b => 'memes', :a => 'PLS'}

for i in 1..100000 do
    if a.keys != [:b, :a] || a.values != ['memes', 'PLS']
        puts 'UH OH IT HECKED'
        exit
    end
end

puts 'they\'re always the same'