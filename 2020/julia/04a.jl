filename = getindex(ARGS, 1)

f = open(filename)

lines = readlines(f)

valid_passports = 0

passports = String[]

passport = ""

for line in lines
    if line == ""
#        println(passport)
        push!(passports, passport)
        global passport = ""
    end
    if passport == ""
        global passport = line
    else
        global passport = passport * " " * line
    end
end

#println(passport)
push!(passports, passport)

println( "total passports: ", length(passports))

for evalpp in passports
    #println(evalpp)
    spaces = count( " ", evalpp )
    if spaces == 7
        global valid_passports += 1
    elseif spaces == 6 && ! occursin( "cid", evalpp )
        global valid_passports += 1
    end
end

println("valid passports: ", valid_passports)
