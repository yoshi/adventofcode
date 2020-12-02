filename = getindex(ARGS, 1)

f = open(filename)

lines = readlines(f)

for a in lines, b in lines, c in lines
    aint = parse(Int64, a)
    bint = parse(Int64, b)
    cint = parse(Int64, c)
    if( aint + bint + cint == 2020 )
        println( aint * bint * cint )
        return
    end
end
