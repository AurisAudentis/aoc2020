x = readlines("inputs/input7")

function parse_line(line)
    parent, children = split(line, " contain ")
    parent_regex = r"^(.*) bags$"

    children_regex = r"([0-9]) ([a-z]* [a-z]*)"
    parent = match(parent_regex, parent)[1]

    parse_child(child) = parse(Int, child[1]), child[2]

    children = eachmatch(children_regex, children)
    parent, map(parse_child, children)
end

function create_dicts(all_lines)
    parents_map = Dict()
    children_map = Dict{AbstractString, Vector{Tuple{AbstractString, Int64}}}()

    for line in all_lines
        parent, children = parse_line(line)
        for (amount, child) in children
            push!(get!(parents_map, child, []), parent)
            push!(get!(children_map, parent, []), (child, amount))
        end
    end

    parents_map, children_map
end

function contains_this!(list, this, parent_map)
    if !haskey(parent_map, this)
        return list
    end

    union!(list, Set(parent_map[this]))
    for parent in parent_map[this]
        contains_this!(list, parent, parent_map)
    end
    return list
end


function must_contain(this, children_map)
    if !haskey(children_map, this)
        return 1
    end

    one_child((a, b)) = b * must_contain(a, children_map)


    reduce(+, one_child.(children_map[this])) + 1
end

parents_map, children_map = create_dicts(x)

println(length(contains_this!(Set(), "shiny gold", parents_map)))

println(must_contain("shiny gold", children_map) - 1)