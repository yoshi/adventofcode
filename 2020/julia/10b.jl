function cost_finder( a )
    cost = 1

    run_counter = 0
    for i in 1:length(a)-1
        if a[i] + 1 ==  a[i+1]
            run_counter += 1
        else
            if run_counter == 2
                cost *= 2
            elseif run_counter == 3
                cost *= 4
            elseif run_counter == 4
                cost *= 7
            end
            run_counter = 0
        end
    end

    return cost
end

lines = parse.(Int64, split(strip(read(getindex(ARGS, 1),String)), "\n"))

println( "the input size is ", length(lines), " lines long.")

sorted_nums = sort( lines )
pushfirst!(sorted_nums,0)
append!(sorted_nums, sorted_nums[end]+3)

println( "cost: ", cost_finder(sorted_nums))
