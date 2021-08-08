using Base: first_index
input = "469217538"

numbers = parse.(Int, collect(input))

function part1(numbers; i=100)
    currentCup = numbers[1]

    for j in 1:i

        index = findfirst(x -> x == currentCup, numbers)
        takenCupIndices = mod1.([1, 2, 3] .+ index, length(numbers))       
        takenCups = numbers[takenCupIndices]
        numbers = filter(x -> !(x in takenCups), numbers)

        nextCup = mod1(currentCup - 1, max(numbers...))
        while nextCup in takenCups
            nextCup = mod1(nextCup - 1, max(numbers...))
        end

        nextCupIndex = findfirst(x -> x == nextCup, numbers)
        for i in reverse(takenCups)
            insert!(numbers, nextCupIndex + 1, i)
        end

        index = findfirst(x -> x == currentCup, numbers)
        currentCup = numbers[mod1(index+1, length(numbers))]

    end

    index = findfirst(x -> x == 1, numbers)
    join(vcat(numbers[index+1:end], numbers[1:index-1]), "")
end

println(part1(numbers))

mutable struct ListItem
    val::Int64
    next::Union{Nothing, ListItem}
end

function next(i::ListItem; n=1)
    if n < 1
        return i
    end

    for _ in 1:n
        i = i.next
    end
    i
end

function putafter!(i::ListItem, j::ListItem; chain=1)
    n = next(i)
    last = next(j; n=chain-1)

    i.next = j
    last.next = n
end

function find(i::ListItem, val)
    first = i
    i = next(i)
    while i.val != val && first != i 
        i = next(i)
    end
    i
end

function contains(i::ListItem, val)
    f = find(i, val)
    f.val == val
end

function cut!(i::ListItem, n)
    nextNode = next(i)
    lastCut = next(nextNode; n=n-1)
    nextCap = next(lastCut)
    i.next = nextCap
    lastCut.next = nextNode
    nextNode
end

function fromVector(vec)
    f(item) = ListItem(item, nothing)

    items = f.(vec)
    for (i, item) in enumerate(items[1:end-1])
        item.next = items[i+1]
    end

    items[end].next = items[1]
    items[1]
end

function createDict(i::ListItem)
    d = Dict()
    first = i
    d[first.val] = first
    i = next(i)
    while i != first
        d[i.val] = i
        i = next(i)
    end
    d
end


function part2(numbers; i = 10000000, size = 1000000)
    startfrom = max(numbers...) + 1
    current = fromVector(vcat(numbers, startfrom:size))
    direct = createDict(current)

    for j in 1:i
        table = cut!(current, 3)
        v = mod1(current.val - 1, size)
        while contains(table, v)
            v = mod1(v - 1, size)
        end

        target = direct[v]
        putafter!(target, table; chain=3)

        current = next(current)
    end

    s = find(current, 1)
    next(s).val * next(s; n=2).val
end


@time println(part2(numbers))
