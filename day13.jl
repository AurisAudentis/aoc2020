l1, l2 = readlines("inputs/input13")

timestamp = parse(Int, l1)
idlist = split(l2, ",")

function part1(timestamp, idlist)
    s = parse.(Int, filter(f -> f != "x", idlist))
    o = argmin(map(f -> (div(timestamp, f) * f + f), s))
    f = s[o]

    f * (div(timestamp, f) * f + f - timestamp)
end

function solve(pairlist)
    if length(pairlist) == 1
        return pairlist[1][2] - pairlist[1][1]
    end

    i = solve(pairlist[1:end-1])
    target, m = pairlist[end]
    step = prod(f -> f[2], pairlist[1:end-1])


    f(x) = mod(x, m) == mod(-target, m)
    found = false
    while !f(i)
        i += step
    end
    i
end

function part2(idlist)
    s = tryparse.(Int, idlist)
    d = reverse.(sort([(v, i-1) for (i, v) in enumerate(s) if v !== nothing]; rev=true))
    solve(d)
end

println(part1(timestamp, idlist))
println(part2(idlist))
