filename = getindex(ARGS, 1)

f = open(filename)

lines = readlines(f)

min_row = 1024
max_row = 0
my_seat_id = 0

seat_map = Dict()

regex = r"(.{7})(.{3})"

for line in lines
    m = match( regex, line )

    row = parse(Int, "0b" * replace( replace(m[1], "F" => "0"), "B" => "1"))
    col = parse(Int, "0b" * replace( replace(m[2], "L" => "0"), "R" => "1"))

    if row > max_row
        global max_row = row
    end
    if row < min_row
        global min_row = row
    end

    if ! haskey( seat_map, row )
        seat_map[row] = []
    end

    append!(seat_map[row], col)
end

for i in min_row+1:max_row-1
    if length(seat_map[i]) != 8
        for j in 0:7
            if findfirst( isequal(j), seat_map[i] ) == nothing
                println("your seat: ", i, " ", j, " ", i * 8 + j)
            end
        end
    end
end

