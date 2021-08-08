x = hcat(collect.(readlines("inputs/input11"))...)
x = permutedims(x, [2,1])

function wrap(array)
    hsize, vsize = size(array)
    hline = fill('.', (hsize + 2, 1))
    vline = fill('.', (1, vsize))
    hcat(hline, vcat(vline, array, vline), hline)
end

function cellular_automaton(array; f=get_immedeate_vicinity)
    wrapped = wrap(array)
    l = step(wrapped; f=f)
    while wrapped != l
        wrapped = l
        l = step(l; f=f)
    end

    count(f -> f === '#', l)
end


const coords = [(i,j) for i in -1:1 for j in -1:1 if !(i === 0 && j ===0)]

function step(wrapped_array; f=get_immedeate_vicinity)
    cp = deepcopy(wrapped_array)
    hsize, vsize = size(wrapped_array)
    for h in 2:hsize-1, v in 2:vsize-1
        s = map(x -> f(x, [h, v], wrapped_array), coords)
        cp[h,v] = transform(wrapped_array[h,v], s)
    end
    cp
end

function transform(sign, tokens)
    global limit
    if sign =='L'
        c = count(f -> f=='#', tokens)
        return c == 0 ? '#' : 'L'
    elseif sign == '#'
        c = count(f -> f=='#', tokens)
        return c >= limit ? 'L' : '#'
    end
    return sign
end

function get_immedeate_vicinity(direction, index, wrapped_array)
    return wrapped_array[(index .+ direction)...]
end

function get_long_vicinity(direction, index, wrapped_array)
    hm, vm = size(wrapped_array)
    i,j = index = direction .+ index
    while 1 <= i <= hm && 1 <= j <= vm  && wrapped_array[index...] == '.'
        i,j = index = direction .+index
    end
    
    1 <= i <= hm && 1 <= j <= vm ? wrapped_array[index...] : '.'
end

limit = 4
println(cellular_automaton(x))
limit = 5

println(cellular_automaton(x; f=get_long_vicinity))