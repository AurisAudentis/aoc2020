readInput() = split.(split(read(joinpath(@__DIR__, "inputs/input6"), String), "\n\n"))


function solve(lines, f=union)
    sum(length.(combine.(lines, f)))
end

function combine(line,f)
    f(Set.(line)...)
end
println(solve(readInput()))
println(solve(readInput(), intersect))