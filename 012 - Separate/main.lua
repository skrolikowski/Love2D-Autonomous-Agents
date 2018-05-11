--=======================================
-- filename:    main.lua
-- author:      Shane Krolikowski
-- created:     Mar, 2018
-- description: Bootstrapper.
--=======================================

Vec2     = require 'tools.vec2'
UMath    = require 'tools.utils.math'
Steering = require 'tools.algorithms.steering'
Entity   = require 'entities.entity'
Vehicle  = require 'entities.vehicle'

WORLD = {
    width  = love.graphics.getWidth(),
    height = love.graphics.getHeight()
}

GAME = {
    debug = false
}

love.graphics.setBackgroundColor(255,255,255,255)

local vehicles = {}
local random   = love.math.random
local limit    = 120

function love.load()
    local vehicle

    for i = 1, limit do
        vehicle     = Vehicle(random(100, 500), random(100, 500))
        vehicle.vel = Vec2():toAngle(
            random(0, math.pi * 2),
            random(1, 3)
        )

        table.insert(vehicles, vehicle)
    end
end

function love.update(dt)
    local separate

    for _, vehicle in pairs(vehicles) do
        separate = Steering:separate(vehicle, vehicles, 50)

        vehicle:applyForce(separate)
        vehicle:update(dt)
    end
end

function love.draw()
    for _, vehicle in pairs(vehicles) do
        vehicle:draw()
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end