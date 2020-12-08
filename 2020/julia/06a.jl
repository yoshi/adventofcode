pps = replace( replace( read(getindex(ARGS, 1),String), "\n\n" => "|"), "\n" => "")

total_qcount = 0

for g in split( pps, "|")
    qcount = length( unique( split(g, "")))
    global total_qcount += qcount
end

println("count: ", total_qcount)
