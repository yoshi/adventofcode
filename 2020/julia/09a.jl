lines = split(strip(read(getindex(ARGS, 1),String)), "\n")

println( "the input size is ", length(lines), " lines long.")

for i = 26:length(lines)
#    println( "lets find what adds up to ", lines[i] )
    iterm = parse(Int64, lines[i])
    iterm_found_parents = false
    for j = i-25:i-1
        jterm = parse(Int64, lines[j])
        #println( "$i $j: ", lines[j])
        for k = i-25:i-1
            kterm = parse(Int64, lines[k])
            if k==j
                continue
            end
            if iterm == jterm + kterm
#                println( lines[i], " = ", lines[j], " + ", lines[k] )
                iterm_found_parents = true
                break
            end
        end
    end

    if !iterm_found_parents
        println( "could not find parents for ", iterm)
    end
end
