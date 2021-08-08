x = readlines("inputs/input4")

function parse_passport_list(list) 
    i = 1
    s = []
    while i <= length(list)
        current = list[i]
        str = ""
        while current != "" && i < length(list)
            str *= " " * current
            i += 1
            current = list[i]
        end
        push!(s, parse_passport(str))
        i += 1
    end
    s
end

function parse_passport(string)
    Dict((parse_field(field) for field in split(string, ' ', keepempty=false)))
end

function parse_field(string)
    split(string, ':')
end

function part1(list, keys)
    valid(p) = count(haskey.(Ref(p), keys)) >=7
    count(valid.(list))
end

function part2(list, dict)

    valid(p) = all(( (haskey(dict, key) && dict[key](value)) for (key, value) in pairs(p)  )) && (haskey(p, "cid") ? length(keys(p)) == 8 : length(keys(p)) == 7)
    count(valid.(list))
end

validation = Dict(
                "byr"=> (v -> 1920 <= parse(Int, v) <= 2002) 
             , "iyr" => (v -> 2010 <= parse(Int, v) <= 2020)
             , "eyr" => (v -> 2020 <= parse(Int, v) <= 2030)
             , "hgt" => (v -> tryparse(Int, chop(v, tail=2)) !== nothing && (occursin("cm", v) ? 
                                                    150 <= tryparse(Int, chop(v, tail=2)) <= 193
                                                    :
                                                    59 <= tryparse(Int, chop(v, tail=2)) <= 76)),
              "hcl" => (v -> occursin(r"^#[0-9a-f]{6}$", v))
              , "ecl" => (v -> v in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]), 
              "pid" => (v -> occursin(r"^[0-9]{9}$", v))
              , "cid" => (v -> true))

pw_list = parse_passport_list(x)
@time println(part1(pw_list, keys(validation)))
@time println(part2(pw_list, validation))
