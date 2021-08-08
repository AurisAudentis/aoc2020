input = [16,11,15,0,1,7]
input2 = [0,3,6]

function part1(starting_numbers, until=2020)
    turn = 0
    memory = Dict()
    for (i,v) in enumerate(starting_numbers)
        memory[v] = i
        turn += 1
    end


    turn += 1
    currnum = 0
    push!(starting_numbers, currnum)
    while length(starting_numbers) < until
        a = next(turn, currnum, memory)
        memory[currnum] = turn
        push!(starting_numbers, a)
        currnum = a
        turn += 1
    end
    starting_numbers[end]
end

function next(turn, number, memory)
    if haskey(memory, number)
        b = memory[number]
        return turn - b
    else
        return 0
    end
end

println(part1(input))
println(code_typed(part1(input; until=30000000)))