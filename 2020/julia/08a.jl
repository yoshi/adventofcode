prog = split(strip(read(getindex(ARGS, 1),String)), "\n")

println( "this program is ", length(prog), " lines long.")

ex_count = zeros( length(prog) )

a = 0
pc = 1

interrupt = false

while ! interrupt
    (inst, op) = split(prog[pc], " " )

    if pc > length(prog)
        println( "program completed" )
        global interrupt = true
        break
    end

    if ex_count[pc] > 0
        println( "pc: ", pc, " loop detected - terminated" )
        global interrupt = true
        break
    end

    ex_count[pc] += 1
    if inst == "nop"
        global pc += 1
    elseif inst == "acc"
        global a = eval(Meta.parse("$a $op"))
        global pc += 1
    elseif inst == "jmp"
        global pc = eval(Meta.parse("$pc $op"))
    end
end

println( "at termination pc = ", pc, " a = ", a )

