include("computer.jl")
x = readlines("inputs/input8")


function find_loop(lines)
    c = create_computer(lines)
    executed_memory = Set()
    while !(c.ip in executed_memory)
        push!(executed_memory, c.ip)
        step(c)
    end
    c.r1
end

function run_until_loop(computer)
    mem = Set()
    function should_stop(computer)
        if computer.ip in mem
            return true
        end
        push!(mem, computer.ip)
        return false
    end

    run(computer; callback=should_stop)
end

function modify(lines)
    c = create_computer(lines)
    i = 1
    done = false
    while i <= length(lines) && !done
        reset(c)
        instr, value = c.instructions[i]
        if instr == "nop"
            c.instructions[i] = ("jmp", value)
            done = run_until_loop(c)
            c.instructions[i] = ("nop", value)
        elseif instr == "jmp"
            c.instructions[i] = ("nop", value)
            done = run_until_loop(c)
            c.instructions[i] = ("jmp", value)
        end
        i+=1
    end
    c.r1
end

@time println(find_loop(x))
@time println(modify(x))