filename = getindex(ARGS, 1)

f = open(filename)

lines = readlines(f)

valid_passwords = 0

pwregex = r"(\d+)-(\d+) (\w): (\w+)"

for pwchk in lines
    (pos1,pos2,pwch,pw) = match(pwregex, pwchk).captures
    ipos1 = parse(Int64, pos1)
    ipos2 = parse(Int64, pos2)

    if xor( pw[ipos1:ipos1] == pwch, pw[ipos2:ipos2] == pwch )
        global valid_passwords = valid_passwords + 1
    end
end

println(valid_passwords)
