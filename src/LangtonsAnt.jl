#=
Fun stuff.

Usage:

@time grid = langtons_ant(100, 10600)
display(grid)
# NOTE that colors on the image will be inverted.
# NOTE this requires `using Images`
save("Ant.png", colorview(Gray, grid))
@show sum(grid)

Interesting discussion here:
https://adambaskerville.github.io/posts/LangtonsAnt/
=#

function langtons_ant(N::Integer, steps::Integer=10)

    # instantiate NxN matrix of zeros
    grid = zeros((N,N))

    # start ant in the middle
    ant_pos = [N ÷ 2, N ÷ 2]

    # define a column-vector that holds the information for the current orientation.
    # this means that the ant is starting out facing east.
    # NOTE it does not matter what the initial orientation is, will only shift the resulting
    # image among one of four possibilites
    direction = [1; 0]

    # rotation matricies for clockwise and counterclockwise rotations
    # NOTE that all angles in this case are 90 degrees hence why everything is 0's and 1's
    cw = [[0 1]; [-1 0]]
    ccw = [[0 -1]; [1 0]]

    # loop until edge of world is hit or steps is exceeded.
    for _ in 1:steps

        # check collision with edge of the world (if ant is on border)
        if 0 in ant_pos || N in ant_pos
            print("Hit edge of board")
            return grid

        # if lands on white, flip cell to black and rotate cw
        elseif grid[ant_pos[1], ant_pos[2]] == 0
            grid[ant_pos[1], ant_pos[2]] = 1
            direction = cw * direction

        # if lands on black. flip cell to white and rotate ccw
        else
            grid[ant_pos[1], ant_pos[2]] = 0
            direction = ccw * direction

        end

        # NOTE that the link at the top moves and then performs the color flip.
        # however, we are doing this for a Project Euler problem that calls for the
        # move to happen after the flip.
        ant_pos = ant_pos .+ direction

    end
    return grid
end
