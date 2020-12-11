lines = parse.(Int64, split(strip(read(getindex(ARGS, 1),String)), "\n"))

println( "the input size is ", length(lines), " lines long.")

sorted_nums = sort( lines )

pushfirst!(sorted_nums,0)
append!(sorted_nums, sorted_nums[end]+3)
#println( sorted_nums )

counts = Dict()
counts[1] = 0
counts[2] = 0
counts[3] = 0


for i in 1:length(sorted_nums)-1
#    println( sorted_nums[i+1] - sorted_nums[i])
    counts[sorted_nums[i+1] - sorted_nums[i]] += 1
end

println( counts[1] * counts[3])
