prog = split(strip(read(getindex(ARGS, 1),String)), "\n")

println( "this program is ", length(prog), " lines long.")

for i in 1:length(prog)

    ex_count = zeros( length(prog) )

    a = 0
    pc = 1

    interrupt = false

    while ! interrupt
        if pc > length(prog)
            println( "EX ", i, " completed normally pc = ", pc, " a = ", a )
            interrupt = true
            break
        end

        if ex_count[pc] > 0
            println( "EX ", i, " loop detected pc = ", pc, " a = ", a )
            interrupt = true
            break
        end

        (inst, op) = split(prog[pc], " " )

        # just in time monkey patching
        if pc == i
            if inst == "nop"
                inst = "jmp"
            elseif inst == "jmp"
                inst = "nop"
            end
        end

        ex_count[pc] += 1
        if inst == "nop"
            pc += 1
        elseif inst == "acc"
            a = eval(Meta.parse("$a $op"))
            pc += 1
        elseif inst == "jmp"
            pc = eval(Meta.parse("$pc $op"))
        end
    end

end

