readInput() = split.(split(read(joinpath(@__DIR__, "inputs/input20"), String), "\n\n"; keepempty=false), "\n"; keepempty=false)

function parseTile(tile)
    first, grid... = tile
    id = parse(Int, match(r"[^0-9]*([0-9]+).*", first).captures[1])
    id, hcat(collect.(grid)...)
end

function allRotations(tile)
    id, grid = tile
    g2 = rotr90(grid)
    g3 = rot180(grid)
    g4 = rotl90(grid)
    rev1 = reverse(grid; dims=1)
    rev2 = reverse(grid; dims=2)
    gr2 = rotr90(rev1)
    gr3 = rot180(rev1)
    gr4 = rotl90(rev1)
    gl2 = rotr90(rev2)
    gl3 = rot180(rev2)
    gl4 = rotl90(rev2)

    (id, grid), (id, g2), (id, g3), (id, g4), (id, rev1), (id, rev2), (id, gr2), (id, gr3), (id, gr4), (id, gl2), (id, gl3), (id, gl4)
end

function bottom(tile)
    _, grid = tile
    grid[:, end]
end

function right(tile)
    _, grid = tile
    grid[end, :]
end

function top(tile)
    _, grid = tile
    grid[:, 1]
end

function left(tile)
    _, grid = tile
    grid[1, :]
end


tiles = parseTile.(readInput())

function part1(tiles)
    matrix = fuse(tiles)
    matrix[1,1][1] * matrix[1,end][1] * matrix[end,1][1] * matrix[end, end][1]
end

function fuse(tiles)
    dims = floor(Int, sqrt(length(tiles)))
    matrix = fill((-1, Array{Char, 2}(undef, 0,0)), (dims, dims))
    @assert fillIn(matrix, 1, 1, tiles) "filling in should work!"
    matrix
end

function fillIn(matrix, i, j, tiles)
    maxi, maxj = size(matrix)
    if j > maxj
        return true
    end

    workingtiles = Set([t for tile in tiles for t in allRotations(tile)])

    if 1 <= j-1 <= maxj
        uptile = matrix[i, j-1]
        bot = bottom(uptile)

        fup(candidate) = bot == top(candidate)

        workingtiles = filter(fup, workingtiles)
    end

    if 1 <= i-1 <= maxi
        uptile = matrix[i-1, j]
        ri = right(uptile)

        fleft(candidate) = ri == left(candidate)

        workingtiles = filter(fleft, workingtiles)
    end

    done = false
    while !done && !isempty(workingtiles)
        t = pop!(workingtiles)
        matrix[i, j] = t
        
        i2 = mod1(i+1, maxi)
        j2 = i2 == 1 ? j+1 : j

        done = fillIn(matrix, i2, j2, filter(s -> s[1] != t[1], tiles))
    end
    done
end

function flattenMatrix(matrix)
    s1, s2 = size(matrix[1])
    s1, s2 = s1, s2
    o1, o2 = size(matrix)
    new = fill('o', (s1*o1,s2*o2))

    for c in CartesianIndices(matrix), co in CartesianIndices(matrix[c][2:end-1, 2:end-1])
        nc = ((c - CartesianIndex(1,1)) * (s1-2)) + co
        new[nc] = matrix[c][2:end-1, 2:end-1][co]
    end
    new
end 

function part2(tiles)
    matrix = [s[2] for s in fuse(tiles)]
    pattern = split("""
                      # 
    #    ##    ##    ###
     #  #  #  #  #  #   
    """, "\n"; keepempty=false)

    
    matrix = flattenMatrix(matrix)

    swappedmatrices = [s[2] for s in allRotations((-1, matrix))]
    coords = findall(x -> x == '#', permutedims(hcat(collect.(pattern)...)))
    found = zeros(Int, size(swappedmatrices))

    for (i, m) in enumerate(swappedmatrices), c in CartesianIndices(m)
        if all(get(m, c + co, ' ') == '#' for co in coords)
            found[i] += 1
        end
    end
    count(f -> f == '#', matrix) - 15*max(found...)
end

display(part2(tiles))
