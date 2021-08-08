function parse_instructions(line)
    instr, arg = match(r"^([a-z]+) ([-+][0-9]+)$", line).captures

    instr, parse(Int, arg)
end

function create_computer(lines)
    instructions = parse_instructions.(lines)
    Computer(instructions, 1, 0)
end

mutable struct Computer
    instructions::Vector{Tuple{AbstractString, Int64}}
    ip::Int64
    r1::Int64
end

function standard_instruction(f)
    return (computer, value) -> begin
        f(computer, value)
        computer.ip += 1
    end
end

function acc(computer, value)
    computer.r1 += value
end

function jmp(computer, value)
    computer.ip += value
end

dispatchDict = Dict("acc" => standard_instruction(acc), "jmp" => jmp, "nop" => standard_instruction((_, _) -> nothing))


function dispatch(computer, (instruction, value))
    @assert haskey(dispatchDict, instruction)
    dispatchDict[instruction](computer, value)
end

function step(computer)
    instruction = computer.instructions[computer.ip]
    dispatch(computer, instruction)
end

function run(computer; callback=nothing)
    cb_done = false
    while computer.ip <= length(computer.instructions) && !cb_done
        step(computer)
        if callback !== nothing
            cb_done = callback(computer)
        end
    end

    !cb_done && (computer.ip - length(computer.instructions) > 1 ? false : true)
end

function reset(computer)
    computer.r1 = 0
    computer.ip = 1
end


export Computer, create_computer, step, run, reset