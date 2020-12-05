filename = getindex(ARGS, 1)

f = open(filename)

lines = readlines(f)

max_seat_id = 0

regex = r"(.{7})(.{3})"
for line in lines
    m = match( regex, line )

    row = parse(Int, "0b" * replace( replace(m[1], "F" => "0"), "B" => "1"))
    col = parse(Int, "0b" * replace( replace(m[2], "L" => "0"), "R" => "1"))

    seat_id = row * 8 + col

    if seat_id > max_seat_id
        global max_seat_id = seat_id
    end
end

println("max_seat_id: ", max_seat_id)
