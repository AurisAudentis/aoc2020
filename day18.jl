x = readlines("inputs/input18")


function doop(lhs, op, rhs)
    if op == '+'
        return lhs+rhs
    elseif op == '*'
        return lhs*rhs
    end
end


function eval1(expr, i=1)
    n = 0
    op = '+'
    while i <= length(expr)
        if expr[i] == '+'
            op = '+'
        elseif expr[i] == '*'
            op = '*'
        elseif '0' <= expr[i] <= '9'
            num = parse(Int, expr[i])
            n = doop(n, op, num)
        elseif expr[i] == '('
            (i, v) = eval1(expr, i+1)
            n = doop(n, op, v)
        elseif expr[i] == ')'
            return i,n
        end
        i += 1
    end 
    return i,n
end

function part1(input)
    sum(x[2] for x in eval1.(input))
end

function eval(input, i=1) 
    i, n = parseTerm(input, i)
    while i <= length(input) && input[i] == '*'
        i += 1
        i, f = parseTerm(input, i)
        n *= f
    end
    return i+1, n
end
1
function parseTerm(input, i=1)
    i, n = parseFunctor(input, i)

    while i < length(input) && input[i] == '+'
        i += 1
        (i, f) = parseFunctor(input, i)
        n += f
    end
    return i, n
end

function parseFunctor(input, i=1)
    if input[i] == '('
        return eval(input, i+1)
    end

    return parseLiteral(input, i)
end

function parseLiteral(input, i = 1)
    @assert '0' <= input[i] <= '9'
    return i+1, parse(Int, input[i])
end

function part2(input)
    sum(x[2] for x in eval.(replace.(input, " "=>"")))

end

println(part1(x))
println(part2(x))