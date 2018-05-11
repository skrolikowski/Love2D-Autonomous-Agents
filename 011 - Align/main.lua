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

local vehicles = {}
local random   = love.math.random
local limit    = 50

function love.load()
    local vehicle

    for i = 1, limit do
        vehicle     = Vehicle(random(0, WORLD['width']), random(0, WORLD['height']))
        vehicle.maxSpeed = random(2, 5)
        vehicle.color    = UMath:lerpColor(
            UMath:map(vehicle.maxSpeed, 2, 5, 0, 1),
            {0,0,0,100},
            {0,0,0,255}
        )

        table.insert(vehicles, vehicle)
    end
end

function love.update(dt)
    local align, wander

    for _, vehicle in pairs(vehicles) do
        wander = Steering:wander(vehicle)
        align  = Steering:align(vehicle, vehicles, 50)

        vehicle:applyForce(wander)
        vehicle:applyForce(align)
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