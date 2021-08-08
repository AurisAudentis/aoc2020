using Base.Iterators
x = parse.(Int, readlines("inputs/input1"))


function findSumWithIterators(l, sums, el=2)
    isSum(l) = sum(l) === sums
    repeated(l, el) |> x -> product(x...) |> x -> Iterators.filter(isSum, x) |> Iterators.first |> prod
end

# println(isSum([1,2]))
@time println(findSumWithIterators(x, 2020))
@time println(findSumWithIterators(x, 2020, 3))