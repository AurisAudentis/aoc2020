using DataStructures

x = parse.(Int, readlines("inputs/input9"))

function has_pair(s, numb)
    any(((abs(x - numb) in s) for x in s))
end

function rolling_sum(numbers, n=25)
    head, tail = numbers[1:n], numbers[n+1:end]
    q = head
    s = Set(head)

    i = 1
    number = tail[1]
    while has_pair(s, number)
        x = popfirst!(q)
        delete!(s, x)
        push!(q, tail[i])
        push!(s, tail[i])
        i += 1
        number = tail[i]
    end

    number
end

function contiguous_sum(numbers)
    target = rolling_sum(numbers)

    csum = cumsum(numbers)
    upper_locs = Set(.-(csum, target))
    
    l = (findfirst(x -> x == y, csum) for y in upper_locs)
    a = first((Iterators.filter(f -> f !== nothing, l)))

    b = findfirst(x -> x === csum[a]+target, csum)


    least, most = min(numbers[a+1:b]...), max(numbers[a+1:b]...)
    least+most
end


println(rolling_sum(x))
println(contiguous_sum(x))