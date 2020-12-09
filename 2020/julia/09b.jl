lines = parse.(Int64, split(strip(read(getindex(ARGS, 1),String)), "\n"))

println( "the input size is ", length(lines), " lines long.")

suspect_term = nothing

for i = 26:length(lines)
#    println( "lets find what adds up to ", lines[i] )
    iterm = lines[i]
    iterm_found_parents = false
    for j = i-25:i-1
        jterm = lines[j]
        #println( "$i $j: ", lines[j])
        for k = i-25:i-1
            kterm = lines[k]
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
        global suspect_term = iterm
        println( "could not find parents for ", iterm)
    end
end

range_found = false

window = 2

println( "in search of... ", suspect_term )
while ! range_found
    for window_start in 1:length(lines) - window
        v = view(lines, window_start:window_start+window )
        if reduce( +, v ) == suspect_term
            println( "found it at $window_start - $window" )
            global range_found = true

            sum_win = sort(v)

            println( "weakness: ", sum_win[length(sum_win)] + sum_win[1] )
            break
        end
    end

    if ! range_found
        if window < length(lines)
            global window += 1
        else
            println( "window too large ", window )
            break
        end
    else
    end
end
