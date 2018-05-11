--=======================================
-- filename:    main.lua
-- author:      Shane Krolikowski
-- created:     Mar, 2018
-- description: Bootstrapper.
--=======================================

Vec2     = require 'tools.vec2'
UMath    = require 'tools.utils.math'
Steering = require 'tools.algorithms.steering'
SManager = require 'tools.utils.steermanager'
Vehicle  = require 'entities.vehicle'

WORLD = {
    width  = love.graphics.getWidth(),
    height = love.graphics.getHeight()
}

GAME = {
    debug = true
}

love.graphics.setBackgroundColor(255,255,255,255)

local followers = {}
local random    = love.math.random
local limit     = 5
local leader, cursor

function love.load()
    local follower

    cursor = Vec2(love.mouse.getPosition())
    leader = Vehicle(random(0, WORLD['width']), random(0, WORLD['height']))

    for i = 1, limit do
        follower       = Vehicle(random(0, WORLD['width']), random(0, WORLD['height']))
        follower.color = {0,0,255,255}

        table.insert(followers, follower)
    end
end

function love.update(dt)
    leader.steer:arrive(cursor, 100)

    leader.pos = leader:nextPosition(dt)
    leader:wrap()

    for _, follower in pairs(followers) do
        follower.steer:followLeader(leader)
        follower.steer:separate(followers, 50)

        follower.pos = follower:nextPosition(dt)
        follower:wrap()
    end
end

function love.draw()
    leader:draw()

    for _, follower in pairs(followers) do
        follower:draw()
    end
end

function love.mousemoved(x, y, dx, dy)
    cursor.x = x
    cursor.y = y
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end