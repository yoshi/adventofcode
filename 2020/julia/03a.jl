filename = getindex(ARGS, 1)

f = open(filename)

lines = readlines(f)

i = 0
j = 0
width = length(lines[1])

tree_count = 0

for line in lines
    if line[begin+j] == '#'
        global tree_count += 1
    end
    global j = mod(j + 3, width)
end

println(tree_count)
