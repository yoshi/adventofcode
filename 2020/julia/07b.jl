lines = split(strip(read(getindex(ARGS, 1),String)), "\n")

# ignore quantites for now and just look at container relaionships.

contained_by = Dict()

bag_value = Dict()

for line in lines
    # parse the rule
    # the rule parser could be a regex, ya?

    line = replace( line, "bags" => "" )
    line = replace( line, "bag" => "" )
    line = replace( line, "." => "" )

    (container, contains) = strip.(split( line, " contain "))

    container = strip(container)

    contents = strip.(split( contains, ","))

#    println( container, " => ", contents )

    for content in contents
        if( content == "no other" )
            bag_value[container] = 1
            break
        else
            if !haskey(bag_value, container)
                bag_value[container] = "1"
            end
        end

        (bag_count, bag_type) = match( r"(\d+) (\w+(?:\s\w+)*)", content ).captures

        bag_value[container] *= " + " * bag_count * " * " * bag_type
    end

    #println( container, " = ", bag_value[container] )
end

# do evals until all strings are converted to values
strings_evaluated = true
while strings_evaluated
    global strings_evaluated = false
    for c in keys(bag_value)
#        println( c, "before: ", bag_value[c])
        if typeof( bag_value[c] ) == String
            for ci in keys(bag_value)
                if typeof( bag_value[ci]) == Int
                    bag_value[c] = replace( bag_value[c], ci => bag_value[ci] )
                end
            end
            if !contains( bag_value[c], r"[a-z]")
                global strings_evaluated = true
                bag_value[c] = eval(Meta.parse(bag_value[c]))
            end
        end
#        println( c, " after: ", bag_value[c])
    end
end

println( "the value of a shiny gold bag is ", bag_value["shiny gold"], " and it contains ", bag_value["shiny gold"] - 1, " bags")

# output all values
#for k in keys(bag_value)
#    println( k, " ", bag_value[k] )
#end
