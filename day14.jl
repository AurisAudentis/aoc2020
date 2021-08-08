x = split.(readlines("inputs/input14"), "=")


function part1(x) 
    memory = Dict()
    mask1 = 0
    mask0 = 0
    for (command, value) in x
        if command == "mask "
            mask1 = parse(Int, replace(value, "X"=>"1"), base=2)
            mask0 = parse(Int, replace(value, "X"=>"0"), base=2)
        else
            addr = parse(Int, command[5:end-2])
            val = parse(Int, value)
            val = val | mask0
            val = val & mask1
            memory[addr] = val
        end
    end

    sum(values(memory))
end


function get_all_masks(addr, mask)
    l = bitstring(addr)[end - length(mask) + 1: end]

    addresses = [[]]
    for (addrbit, maskbit) in zip(l, mask)
        if maskbit == '1'
            for address in addresses
                push!(address, '1')
            end
        elseif maskbit == '0'
            for address in addresses
                push!(address, addrbit)
            end
        else
            newaddr = []
            for address in addresses
                push!(newaddr, push!(copy(address), '0'))
                push!(address, '1')
            end
            push!(addresses, newaddr...)
        end
    end
    join.(addresses)
end

function part2(x) 
    memory = Dict()
    mask = ""
    xlist = []
    for (command, value) in x
        if command == "mask "
            mask = strip(value)
        else
            addr = parse(Int, command[5:end-2])
            val = parse(Int, value)

            hold = get_all_masks(addr, mask)
            for i in hold
                i = parse(Int, i, base=2)
                memory[i] = val
            end
        end
    end

    sum(values(memory))
end

println(part1(x))
println(part2(x))