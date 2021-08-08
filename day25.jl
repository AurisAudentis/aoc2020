key1, key2 = readlines("inputs/input25")
key1, key2 = parse(Int, key1), parse(Int, key2)
println(key1, key2)

function determineLoopSize(key; n=7)
    val = n
    i = 0
    while val != key
        val = val * n
        val = val % 20201227
        i+=1
    end
    return i
end

function transform(value, loopsize)
    v = value
    for _ in range(0, stop=loopsize-1)
        value = value * v
        value = value % 20201227
    end
    return value
end

function part1(key1, key2)
    doorLoopSize = determineLoopSize(key1)
    cardLoopSize = determineLoopSize(key2)
    
    return transform(key1, cardLoopSize), transform(key2, doorLoopSize)
end

@time println(part1(key1, key2))