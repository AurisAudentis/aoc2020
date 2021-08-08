using StatsBase
x =  readlines("inputs/input2")

function analyze_password_1(line)
    lower, upper, letter, password = parse_password(line)
    letter_count = StatsBase.countmap(password)
    get(letter_count, letter, 0) >= lower && get(letter_count, letter, 0) <= upper
end

function analyze_password_2(line)
    a, b, letter, password = parse_password(line)
    (password[a] == letter || password[b] == letter) && !(password[a] == letter && password[b] == letter)
end

function parse_password(line)
    policy, password = split(line, ":")
    range, letter = split(policy, " ")
    a, b = parse.(Int, split(range, "-"))
    return (a, b, first(letter), strip(password))
end

println(sum(analyze_password_1.(x)))
println(sum(analyze_password_2.(x)))