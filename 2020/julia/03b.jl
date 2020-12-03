filename = getindex(ARGS, 1)

f = open(filename)

lines = readlines(f)

i = 0
j11 = 0
j31 = 0
j51 = 0
j71 = 0
j12 = 0
width = length(lines[1])

tree_count_11 = 0
tree_count_31 = 0
tree_count_51 = 0
tree_count_71 = 0
tree_count_12 = 0

for line in lines
    if line[begin+j11] == '#'
        global tree_count_11 += 1
    end
    if line[begin+j31] == '#'
        global tree_count_31 += 1
    end
    if line[begin+j51] == '#'
        global tree_count_51 += 1
    end
    if line[begin+j71] == '#'
        global tree_count_71 += 1
    end
    if line[begin+j12] == '#' && mod(i,2) == 0
        global tree_count_12 += 1
    end
    global j11 = mod(j11 + 1, width)
    global j31 = mod(j31 + 3, width)
    global j51 = mod(j51 + 5, width)
    global j71 = mod(j71 + 7, width)
    if(mod(i,2) == 0)
        global j12 = mod(j12 + 1, width)
    end
    global i += 1
end

println(tree_count_11)
println(tree_count_31)
println(tree_count_51)
println(tree_count_71)
println(tree_count_12)
println(tree_count_11 * tree_count_31 * tree_count_51 * tree_count_71 * tree_count_12)
