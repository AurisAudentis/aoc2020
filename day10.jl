x = parse.(Int, readlines("inputs/input10"))

sort!(x)

function differential(numbers)
    charger = max(numbers...) + 3
    n = push!(copy(numbers), charger)
    with_zero = pushfirst!(copy(n), 0)
    s = n .- with_zero[1:end - 1]

    count(x -> x === 1, s) * count(x -> x === 3, s) 
end

function chain(numbers)
    target = max(numbers...) + 3
    v = zeros(Int64, target)
    push!(numbers, target)
    for i in numbers
        p = 0
        for j in [1,2,3]
            if i-j == 0
                p += 1
            elseif i-j > 0
                p+=v[i-j]
            end
        end
        v[i]=p
    end
    v[end]
end

println(differential(x))
println(chain(x))