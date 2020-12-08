pps = replace( replace( strip(read(getindex(ARGS, 1),String)), "\n\n" => "|"), "\n" => "^")

total_gacount = 0

for g in split( pps, "|")
    person_count = length(split(g,"^"))
    qs = unique(split(replace(g,"^"=>""),""))
    as = replace(g,"^"=>"")
    ga = 0
    for q in qs
        if count(q, as) == person_count
            ga += 1
        end
    end
    global total_gacount += ga
end

println("total_gacount: ", total_gacount)
