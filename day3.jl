using Base.Iterators
x = readlines("inputs/input3")
field = reshape([i for j in x for i in j], (length(x[1]), length(x)))


function walk(s, direction=[3 1], coordinates=[1 1])
    walk_coordinates = [coordinates]
    while coordinates[2] < s
        coordinates += direction
        push!(walk_coordinates, coordinates)
    end
    walk_coordinates
end

function count_trees(field, direction=[3 1])
    xmax, ymax = size(field)
    transform_index(i) = [mod1(i[1], xmax)  mod1(i[2], ymax)]
    count(map((x -> field[x...]) ∘ transform_index, walk(ymax, direction)) .== '#')
end

println(count_trees(field))

directions = [[1 1], [3 1], [5 1], [7 1], [1 2]]
println(prod((x -> count_trees(field, x)).(directions)))