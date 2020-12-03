filename = getindex(ARGS, 1)

f = open(filename)

lines = readlines(f)

valid_passwords = 0

pwregex = r"(\d+)-(\d+) (\w): (\w+)"

for pwchk in lines
    (minoc,maxoc,pwch,pw) = match(pwregex, pwchk).captures
    iminoc = parse(Int64, minoc)
    imaxoc = parse(Int64, maxoc)

    occurances = count(pwch, pw)

    if iminoc <= occurances && occurances <= imaxoc
        global valid_passwords = valid_passwords + 1
    end
end

println(valid_passwords)
