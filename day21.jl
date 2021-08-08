x = readlines("inputs/input21")

function parseLine(input)
    ingredients, allergens = split(input ,"(contains ")
    ingredients = split(ingredients, " "; keepempty=false)
    allergens = split(allergens[1:end-1], ", "; keepempty=false)
    ingredients, allergens
end

function getAllergenSets(lines)
    allergenSets = Dict()
    for line in lines, allergen in line[2]
        l = get!(allergenSets, allergen, [])
        push!(l, Set(line[1]))
    end
    allergenSets
end
function calculateAssignedIngredients(allergenSets)
    assignedIngredients = Dict()
    chainIntersect(x) = reduce(intersect, x)
    while !isempty(allergenSets)
        for val in values(allergenSets), j in val
            setdiff!(j, values(assignedIngredients))
        end
        allergens = filter(f -> length(chainIntersect(allergenSets[f])) == 1, keys(allergenSets))
        for allergen in allergens
            assignedIngredients[allergen] = only(chainIntersect(allergenSets[allergen]))
        end
        delete!.(Ref(allergenSets), allergens)
    end
    assignedIngredients
end

function part1(lines)
    allergenSets = getAllergenSets(lines)
    assignedIngredients = calculateAssignedIngredients(deepcopy(allergenSets))
    s = 0
    for i in  Set(ingredientset for ingredientlist in values(allergenSets) for ingredientset in ingredientlist)
        s += length(setdiff(i, values(assignedIngredients)))
    end
    s
end

function part2(lines)
    allergenSets = getAllergenSets(lines)
    assignedIngredients = calculateAssignedIngredients(deepcopy(allergenSets))
    flip = Dict(value => key for (key, value) in assignedIngredients)
    join(sort(collect(keys(flip)), by = f -> flip[f]), ",")
end


lines = parseLine.(x)
println(part1(lines))
println(part2(lines))