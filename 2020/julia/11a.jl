function count_adjacent( g, i, j )
    count = 0
    for k in -1:1, l in -1:1
        if ! ( k == 0 && l == 0 )
            if i+k < 1 || i+k > length(g) || l+j < 1 || l+j > length(g)
            else
                if g[i+k][l+j] == "#"
                    count += 1
                end
            end
        end
    end
    return count
end

function count_occupied( g )
    count = 0
    for i in 1:length(g), j in 1:length(g[1])
        if g[i][j] == "#"
            count += 1
        end
    end
    return count
#    return count(g .== "#")
end

function print_grid( g )
    for l in grid
        println(join(l,""))
    end
end


grid = split.(split(strip(read(getindex(ARGS, 1),String)), "\n"),"")

println( "==> generation: 0 occupied: 0" )
#print_grid(grid)

generations = 0

while(true)
    next_grid = deepcopy(grid)

    for i in 1:length(next_grid), j in 1:length(next_grid[1])
        if next_grid[i][j] == "L"
            if count_adjacent(grid, i, j) == 0
                next_grid[i][j] = "#"
            end
        elseif next_grid[i][j] == "#"
            if count_adjacent(grid, i, j) > 3
                next_grid[i][j] = "L"
            end
        end
    end

    if next_grid == grid
        break
    else
        global grid = next_grid
        global generations += 1
        println( "==> generation: $generations occupied: ", count_occupied(grid) )
        print_grid(next_grid)
    end
end

occupied = count_occupied(grid)

println("terminated on generation $generations with $occupied")
