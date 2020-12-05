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
    evalpp = join(sort(split(evalpp," "))," ")
    #println(evalpp)

    # well, convert the string to a Dict?  Hopefully, this is fun.
    # there is an explicit way to do things then the idomatic way.

    ppd = Dict()

    ppa = split(evalpp, " ")
    for av in ppa
        (a,v) = split(av, ":")
        ppd[a] = v
    end

    is_valid = true

    if haskey(ppd, "byr" )
        if length(ppd["byr"]) == 4
            if parse(Int64, ppd["byr"]) >= 1920 && parse(Int64, ppd["byr"]) <= 2002
                println( "valid byr: ", ppd["byr"] )
            else
                println("invalid byr value")
                is_valid = false
            end
        else
            println("invalid byr length")
            is_valid = false
        end
    else
        println("no byr")
        is_valid = false
    end

    if haskey(ppd, "iyr")
        if length(ppd["iyr"]) == 4
            if parse(Int64, ppd["iyr"]) >= 2010 && parse(Int64, ppd["iyr"]) <= 2020
                println( "valid iyr: ", ppd["iyr"])
            else
                println( "invalid iyr value")
                is_valid = false
            end
        else
            println( "invalid iyr length" )
            is_valid = false
        end
    else
        println("no iyr")
        is_valid = false
    end

    if haskey(ppd, "eyr")
        if length(ppd["eyr"]) == 4
            if parse(Int64, ppd["eyr"]) >= 2020 && parse(Int64, ppd["eyr"]) <= 2030
                println( "valid eyr: ", ppd["eyr"])
            else
                println( "invalid eyr value")
                is_valid = false
            end
        else
            println( "invliad eyr value" )
            is_valid = false
        end
    else
        println("no eyr")
        is_valid = false
    end

    #todo
    if haskey(ppd, "hgt")
        if endswith(ppd["hgt"], "cm" ) || endswith(ppd["hgt"], "in" )
            # heh, remove all characters from the string and you are left with a number
            # remove all numbers from the string and you are left with the units
            # gonna do that and then do the verification.  cackle

            height_string = ppd["hgt"]
            #remove characters from height_string
            height_string = replace(height_string, r"[a-z]" => "")
            height = parse(Int64, height_string)

            units = ppd["hgt"]
            #remove numbers from units
            units = replace(units, r"\d" => "" )
            if units == "cm"
                if height >= 150 && height <= 193
                    println( "valid hgt: ", ppd["hgt"])
                else
                    println("cm height out of bounds")
                    is_valid = false
                end
            elseif units == "in"
                if height >= 59 && height <= 76
                    println( "valid hgt: ", ppd["hgt"])
                else
                    println("in height out of bounds")
                    is_valid = false
                end
            else
                println("invalid units")
                is_valid = false
            end
        else
            println("invalid hgt: no units")
            is_valid = false
        end
    else
        println("no hgt")
        is_valid = false
    end

    if haskey(ppd, "hcl")
        # hcl needs to start with a hash and contain only numbers and a-f
        hcl = ppd["hcl"]
        # remove prefix #, a-f, and 0-9
        # omg this is so terrible.  I love it.
        # I suppose these regexes are a precursor to the final regex only soln
        hcl = replace( hcl, r"^#" => "")
        hcl = replace( hcl, r"[0-9a-f]" => "")
        if startswith(ppd["hcl"], "#") && hcl == ""
            println( "valid hcl: ", ppd["hcl"])
        else
            println("hcl invalid format")
            is_valid = false
        end
    else
        println("no hcl")
        is_valid = false
    end

    if haskey(ppd, "ecl")
        if length(ppd["ecl"]) == 3
            if ppd["ecl"] == "amb" || ppd["ecl"] == "blu" || ppd["ecl"] == "brn" || ppd["ecl"] == "gry" || ppd["ecl"] == "grn" || ppd["ecl"] == "hzl" || ppd["ecl"] == "oth"
                println( "valid ecl: ", ppd["ecl"])
            else
                println("invalid eye color")
                is_valid = false
            end
        else
            println( "eye color code out of bounds")
            is_valid = false
        end
    else
        println("no ecl")
        is_valid = false
    end

    if haskey(ppd, "pid")
        if length(ppd["pid"]) == 9
            pid = ppd["pid"]
            pid = replace( pid, r"[0-9]" => "")
            # remove all numbers from pid and then you should have an empty string
            if pid == ""
                println( "valid pid: ", ppd["pid"])
            else
                println("pid contains non-numerics")
                is_valid = false
            end
        else
            println("pid out of bounds")
            is_valid = false
        end
    else
        println("no pid")
        is_valid = false
    end

    if haskey(ppd, "cid")
        # do nothing at all because it is all good
    end

    if is_valid
        global valid_passports += 1
        println("is valid: ", evalpp)
        println()
    else
        println("is invalid: ", evalpp)
        println()
    end
end

println("valid passports: ", valid_passports)
