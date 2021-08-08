x = readlines("inputs/input5")

function parse_part(line)
    rowstring, colstring = line[1:7], line[8:end]

    f(a,b) = 8*a+b
    f(parse_number(rowstring), parse_number(colstring))
end

function parse_number(line)
    translated = (replace(line, "R"=>"1") |>l -> replace(l, "L"=>"0")  |> l ->replace(l, "B"=>"1") |>l -> replace(l, "F"=>"0"))
    parse(Int, translated; base=2)
end

function part1(lines)
    max(parse_part.(lines)...)
end

function part2(lines)
    ids = parse_part.(lines)
    collIds = Set(ids)
    for i in 1:max(collIds...)
        if !(i in collIds) && (i-1 in collIds) && (i+1 in collIds)
            return i
        end
    end
end

@time println(part1(x))
@time println(part2(x))