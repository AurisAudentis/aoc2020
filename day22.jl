readInput() = split.(split(read(joinpath(@__DIR__, "inputs/input22"), String), "\n\n"; keepempty=false), "\n"; keepempty=false)

function parseDeck(lines)
    _, deck... = lines
    parse.(Int, deck)
end

function step(deck1, deck2)
    @assert length(deck1) > 0 && length(deck2)>0 "both must have a card"
    c1 = popfirst!(deck1)
    c2 = popfirst!(deck2)
    
    if c1 > c2
        d = deck1
    else
        d = deck2
    end
    push!(d, max(c1,c2))
    push!(d, min(c1, c2))
    deck1, deck2
end

function part1(lines)
    deck1, deck2 = parseDeck.(lines)
    while !isempty(deck1) && !isempty(deck2)
        deck1,deck2 = step(deck1, deck2)
    end

    d = length(deck1) == 0 ? deck2 : deck1

    sum(prod.(enumerate(reverse(d))))
end

function part2(lines)
    deck1, deck2 = parseDeck.(lines)
    game(deck1, deck2)
    d = length(deck1) == 0 ? deck2 : deck1

    sum(prod.(enumerate(reverse(d))))
end

function game(deck1, deck2)
    played_decks = Set()
    won = -1
    
    # Rounds
    while won == -1
        c1 = popfirst!(deck1)
        c2 = popfirst!(deck2)

        if c1 <= length(deck1) && c2 <= length(deck2)
            winner = game(deck1[1:c1], deck2[1:c2])
        else
            winner = c1 > c2 ? 1 : 2
        end

        winnerdeck = winner == 1 ? deck1 : deck2
        winnercard = winner == 1 ? c1 : c2
        losercard = winner == 1 ? c2 : c1

        push!(winnerdeck, winnercard)
        push!(winnerdeck, losercard)

        won = length(deck1) == 0 ? 2 : won
        won = length(deck2) == 0 ? 1 : won
        won = hash(deck1) in played_decks ? 1 : won
        push!(played_decks, hash(deck1))
    end
    
    won
end 


println(part1(readInput()))
@time println(part2(readInput()))
using ProfileView

@profview println(part2(readInput()))