x = map(s -> (s[1], parse(Int, s[2:end])), readlines("inputs/input12"))

mutable struct Ship
    orientation::Int64
    x::Int64
    y::Int64
end

directions = [(0,1), (-1,0), (0,-1), (1,0)]

function turn1(ship, direction, degrees)
    i = direction == 'R' ? -1 : 1
    ship.orientation += (i * degrees // 90)
    ship.orientation = mod1(ship.orientation, length(directions))
end

function move1(ship, direction, movement)
    if direction == 'N'
        ship.y += movement
    elseif direction == 'S'
        ship.y -= movement
    elseif direction == 'E'
        ship.x += movement
    elseif direction == 'W'
        ship.x -= movement
    elseif direction == 'F'
        x, y = directions[ship.orientation]
        ship.x += x * movement
        ship.y += y * movement
    else
        turn1(ship, direction, movement)
    end
end

s = Ship(4,0,0)
for (direction, movement) in x
    move1(s, direction, movement)
end
println(abs(s.x) + abs(s.y))


mutable struct Waypoint
    x::Int64
    y::Int64
end

rotation_mx = [ [0 -1 ; 1 0], [-1 0 ; 0 -1], [0 1 ; -1 0] ]
function turn2(waypoint, direction, degrees)
    degrees = direction == 'L' ? degrees : 360 - degrees
    degrees = degrees ÷ 90

    waypoint.x, waypoint.y = rotation_mx[degrees] * [waypoint.x, waypoint.y]
end

function move2(ship, waypoint, direction, movement)
    if direction == 'N'
        waypoint.y += movement
    elseif direction == 'S'
        waypoint.y -= movement
    elseif direction == 'E'
        waypoint.x += movement
    elseif direction == 'W'
        waypoint.x -= movement
    elseif direction == 'F'
        x, y = waypoint.x, waypoint.y
        ship.x += x * movement
        ship.y += y * movement
    else
        turn2( waypoint, direction, movement)
    end

end

s = Ship(4,0,0)
wp = Waypoint(10, 1)

for (direction, movement) in x
    move2(s, wp, direction, movement)
end

@time println(abs(s.x) + abs(s.y))
