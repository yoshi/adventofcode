lines = split(strip(read(getindex(ARGS, 1),String)), "\n")

# ignore quantites for now and just look at container relaionships.

contained_by = Dict()

for line in lines
    # parse the rule
    # the rule parser could be a regex, ya?

    line = replace( line, "bags" => "" )
    line = replace( line, "bag" => "" )
    line = replace( line, "." => "" )
    line = replace( line, r"[0-9]" => "")

    (container, contains) = strip.(split( line, " contain "))

    container = strip(container)

    contents = strip.(split( contains, ","))

#    println( container, " => ", contents )

    for content in contents
        if( content == "no other" )
            break
        end

        if( ! haskey( contained_by, content ) )
            contained_by[content] = []
        end
        push!( contained_by[content], container )
#        println( content, " contained_by ", container)
    end
end

unique_containers = Dict()

containers = contained_by[ "shiny gold" ]

while ! isempty(containers)
    eval_container = pop!(containers)
    if ! haskey(unique_containers, eval_container)
        unique_containers[eval_container] = 1
    end
    if haskey( contained_by, eval_container )
        for cb in contained_by[eval_container]
            push!( containers, cb )
        end
    end
end

println( "container_count: ", length(keys(unique_containers)))
