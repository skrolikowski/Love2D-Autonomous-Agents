--=======================================
-- filename:    main.lua
-- author:      Shane Krolikowski
-- created:     Mar, 2018
-- description: Bootstrapper.
--=======================================

Vec2     = require 'tools.vec2'
UMath    = require 'tools.utils.math'
Steering = require 'tools.algorithms.steering'
Vehicle  = require 'entities.vehicle'

WORLD = {
    width  = love.graphics.getWidth(),
    height = love.graphics.getHeight()
}

GAME = {
    debug = false
}

love.graphics.setBackgroundColor(255,255,255,255)

local Obstacle
local random    = love.math.random
local vehicles  = {}
local obstacles = {}

function love.load()
    for i = 1, 50 do
        table.insert(vehicles, Vehicle(WORLD['width'] / 2, WORLD['height'] / 2))
    end

    for i = 1, 10 do
        table.insert(obstacles, Obstacle(
            random(50, 750),
            random(50, 750),
            random(25, 75)
        ))
    end
end

function love.update(dt)
    local avoid, wander

    for _, vehicle in pairs(vehicles) do
        wander = Steering:wander(vehicle)
        avoid  = Steering:avoid(vehicle, obstacles, 100)

        wander:scale(1)
        avoid:scale(2)

        vehicle:applyForce(wander)
        vehicle:applyForce(avoid)
        vehicle:update(dt)
    end
end

function love.draw()
    for _, vehicle in pairs(vehicles) do
        vehicle:draw()
    end

    for _, obstacle in pairs(obstacles) do
        obstacle:draw()
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function Obstacle(x, y, radius)
    local self = {
        pos    = Vec2(x, y),
        radius = radius
    }

    function self:draw()
        love.graphics.setColor(255,0,0,100)
        love.graphics.circle('fill', self.pos.x, self.pos.y, self.radius)

        love.graphics.setColor(255,0,0,255)
        love.graphics.circle('line', self.pos.x, self.pos.y, self.radius)
    end

    return self
end