--=======================================
-- filename:    main.lua
-- author:      Shane Krolikowski
-- created:     Mar, 2018
-- description: Bootstrapper.
--=======================================

Vec2     = require 'tools.vec2'
UMath    = require 'tools.utils.math'
Steering = require 'tools.algorithms.steering'
SManager = require 'entities.steeringmanager'
Vehicle  = require 'entities.vehicle'

WORLD = {
    width  = love.graphics.getWidth(),
    height = love.graphics.getHeight()
}

GAME = {
    debug = true
}

love.graphics.setBackgroundColor(255,255,255,255)

local vehicles  = {}
local obstacles = {}
local random    = love.math.random
local limit     = 10
local target

function love.load()
    local vehicle

    for i = 1, limit do
        vehicle          = Vehicle(random(0, WORLD['width']), 500)
        vehicle.maxSpeed = random(3, 5)
        vehicle.color    = UMath:lerpColor(
            UMath:map(vehicle.maxSpeed, 2, 4, 0, 1),
            {0,0,0,100},
            {0,0,0,255}
        )

        table.insert(vehicles, vehicle)
    end

    -- obstacles
    table.insert(obstacles, Obstacle(100, 150, 100))
    table.insert(obstacles, Obstacle(500, 150, 100))

    -- target (to seek)
    target = Vec2(WORLD['width'] / 2, -50)
end

function love.update(dt)
    for _, vehicle in pairs(vehicles) do
        vehicle.steer:seek(target)
        vehicle.steer:avoid(obstacles, 100)
        vehicle.steer:separate(vehicles, 25)
        vehicle.steer:queue(vehicles)

        vehicle.pos = vehicle:nextPosition(dt)
        vehicle:wrap()
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