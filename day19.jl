readInput() = split.(split(read(joinpath(@__DIR__, "inputs/input19"), String), "\n\n"), "\n")

function parseRule(rule)
    reg = r"\"(.)\""
    if contains(rule, reg)
        letter, = match(reg, rule).captures
        return only(letter)
    end

    rulenum, rest = split(rule, ":")
    rest = split(rest, "|")
    parseSpaceList(l) = parse.(Int, split(strip(l), " "))
    return parseSpaceList.(rest)
end

function applyRule(rule, input, rules, i=1)
    if isa(rule, Char)
        if !(i > length(input)) && input[i] == rule
            return [i+1]
        else
            return [-1]
        end
    end

    return applyRuleFlat(rule, input, rules, i)
end

function applyRuleFlat(rule, input, rules, i)
    reaches = []

    for subrule in rule
        reaches = vcat(reaches, applyChain(subrule, input, [i], rules))
    end
    return reaches
end

function applyChain(chain, input, ilist, rules)

    if length(chain) == 0
        return ilist
    end

    rule, chain... = chain
    reaches = []
    for i in ilist
        indexes = applyRule(rules[rule+1], input, rules, i)
        indexes = [i for i in indexes if i > 0]
        reaches = vcat(reaches, applyChain(chain, input, indexes, rules))
        reaches = [i for i in reaches if i > 0]
    end
    return reaches
end

function part1(rules, messages)
    reaches = applyRule.(Ref(rules[1]), messages, Ref(rules))

    count((t) -> (length(messages[t[1]]) + 1) in t[2], collect(enumerate(reaches)))
end

rules, messages = readInput()
messages = [m for m in messages if length(m) > 0]
sort!(rules, by = r -> parse(Int, split(r, ":")[1]))
rules = (parseRule.(rules))

println(part1(rules, messages))

rules[9] = [[42], [42 8]]
rules[12] = [[42 31], [42 11 31]]

println(part1(rules, messages))
