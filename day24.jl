using Base.Iterators
@enum Color white black

x = readlines("inputs/input24")

mutable struct Tile
    column::Number
    row::Number
    color::Color
end

function part1(lines)
    tiles = getBoard(lines)
    count(t -> t == black, values(tiles))
end

function getBoard(lines)
    tiles = Dict()
    toTurn = walk.(lines)
    foreach(t -> flip(tiles, t), toTurn)
    tiles
end

function walk(walk, coords=(0,0))
    while length(walk) != 0
        coords, walk = step(coords, walk)
    end

    return coords
end

function step(coords, walk)    
    step, walk = getStep(walk)

    return step(coords...), walk
end


function flip(tiles, coords:: Tuple{Int64, Int64})
    if !haskey(tiles, coords)
        tiles[coords] = black
    elseif tiles[coords] == white
        tiles[coords] = black
    else
        tiles[coords] = white
    end
end

stepMap = Dict(
    "w" => (x, y) -> (x - 1, y),
    "e" => (x, y) -> (x + 1, y),
    "se" => (x, y) -> (x + 1, y + 1),
    "sw" => (x, y) -> (x, y + 1),
    "ne" => (x, y) -> (x, y - 1), 
    "nw" => (x, y) -> (x - 1, y - 1)
     )

function getStep(line)
    a, line = line[1], line[2:end]
    if a == 's' || a == 'n'
        b, line = line[1], line[2:end]
        return stepMap[a * b], line
    else
        return stepMap[string(a)], line
    end
end

function part2(walks; n=100) 
    tiles = getBoard(walks)
    for _ in 1:n
        toFlip = Set()
        blackTiles = [coords for (coords, color) in tiles if color == black]
        whiteTiles = filter(f -> get(tiles, f, white) == white, collect(flatten([getEnvironment(c) for c in blackTiles])))

        for tile in blackTiles
            n = count(f ->  get(tiles, f, white) == black, getEnvironment(tile))
            if (n == 0 || n > 2)
                push!(toFlip, tile)
            end
        end

        for tile in whiteTiles
            n = count(f ->  get(tiles, f, white) == black, getEnvironment(tile))
            if n == 2
                push!(toFlip, tile)
            end
        end

        foreach(f -> flip(tiles, f), toFlip)
    end

    count(t -> t == black, values(tiles))
end

function getEnvironment(coords)
    [s(coords...) for s in values(stepMap)]
end

@time println(part1(x))
@time println(part2(x))