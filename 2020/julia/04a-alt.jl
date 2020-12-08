pps = replace( replace( read(getindex(ARGS, 1)), "\n\n" => "|"), "\n" => " ")



# valid passports have 8 elements or 7 elements sans cid
match( r"(?=.*byr:(19[2-9][0-9]|200[012]))", byr)
match( r"iyr:(201[0-9]|2020)", iyr)
match( r"eyr:(202[0-9]|2030)", eyr)
match( r"hgt:(1[5678][0-9]|19[0123]cm", hgt)
match( r"hgt:(59|6[0-9]|7[0-6])in", hgt)
match( r"hcl:#([0-9a-f]{6})", hcl)
match( r"ecl:(amb|blu|brn|gry|grn|hzl|oth)", ecl)
match( r"pid:([0-9]{9})", pid)
match( r"cid:(\w)", cid)
