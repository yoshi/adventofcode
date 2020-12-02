filename = getindex(ARGS, 1)

f = open(filename)

lines = readlines(f)

for a in lines, b in lines
    aint = parse(Int64, a)
    bint = parse(Int64, b)
    if( aint + bint == 2020 )
        println( aint * bint )
        return
    end
end
