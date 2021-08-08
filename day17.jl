using Memoize
x = readlines("inputs/input17")


function parseStart(start, dim=3)
    indices = Set()

    o = zeros(Int, dim-2)
    for (i, line) in enumerate(start), (j, char) in enumerate(line)
        if char == '#' 
            push!(indices, CartesianIndex(i, j, o...))
        end
    end
    indices
end

function neighbours_n_dim(dim)
    if dim == 0
        return [[]]
    end

    smaller = neighbours_n_dim(dim-1)
    [vcat(j, [i]) for i in -1:1 for j in smaller]
end

@memoize function neighbours_n_dim_coord(dim)
    v = neighbours_n_dim(dim)
    f(v) = CartesianIndex(v...)
    f.(v)
end

function neighbours(coord)
    dim = length(coord)

    Ref(coord) .+ neighbours_n_dim_coord(dim)
end

function step(active)
    new = Set()
    lookedat = Set()
    for coord in active
        nb = neighbours(coord)
        if  3 <= count(c -> c in active, nb) <= 4
            push!(new, coord)
        end
        push!(lookedat, coord)
        for n in setdiff(nb, lookedat)
            push!(lookedat, n)
            nnb = neighbours(n)
            if !(n in active) && count(c -> c in active, nnb) == 3
                push!(new, n)
            end
        end
    end
    new
end

function part1(active, it)
    for _ in 1:it
        active = step(active)
    end
    active
end

println(length(part1(parseStart(x), 6)))
@time println(length(part1(parseStart(x, 4), 6)))