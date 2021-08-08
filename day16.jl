readInput() = split.(split(read(joinpath(@__DIR__, "inputs/input16"), String), "\n\n"), "\n")
rules, myticket, alltickets = readInput()

function parserule(rule)
    name, constraints = split(rule, ":")
    constraint1, constraint2 = split(constraints, "or")
    getConstraint(c) = parse.(Int, split(c, "-"))
    name, getConstraint(constraint1), getConstraint(constraint2)
end

function parseticket(ticket)
    parse.(Int, split(strip(ticket),","))
end

prules = (parserule.(rules))
ptickets = (parseticket.(alltickets[2:end-1]))
myticket = parseticket(myticket[2])

evaluateConstraint((l, g), val) = l <= val <= g
evaluateRule((_, a, b), val) = evaluateConstraint(a, val) || evaluateConstraint(b, val)

function getInvalids(prules, ptickets)
    invalid = []
    tickets = []


    for (i, ticket) in enumerate(ptickets), value in ticket
        if !any(evaluateRule.(prules, value))
            push!(invalid, value)
            push!(tickets, i)
        end
    end
    return invalid, tickets
end

function part1(prules, ptickets)
    invalid, _ = getInvalids(prules, ptickets)
    sum(invalid)
end

function part2(prules, ptickets, myTicket)
    _, invalids = getInvalids(prules, ptickets)
    ptickets = ptickets[setdiff(1:length(ptickets), invalids)]

    default_set = Set(1:length(ptickets[1]))
    # find ticket impossibles
    possible_positions = Dict(t => deepcopy(default_set) for t in prules)
    for ticket in ptickets, rule in prules, (i,val) in enumerate(ticket)
            if !evaluateRule(rule, val)
                delete!(possible_positions[rule], i)
            end
    end

    # Topologically sort
    final_position = Dict()

    for _ in 1:length(prules)
        smallest = reduce(((a, b) -> length(possible_positions[a]) < length(possible_positions[b]) ? a : b), keys(possible_positions))
        pos = only(possible_positions[smallest])
        final_position[smallest] = pos
        delete!(possible_positions, smallest)
        for v in values(possible_positions)
            delete!(v, pos)
        end
    end

    prod([myTicket[b] for (a, b) in final_position if startswith(a[1], "departure")])
end

@time println(part1(prules, ptickets))
@time println(part2(prules, ptickets, myticket))