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

local limit    = 25
local vehicles = {}
local seer

function love.load()
    for i = 1, limit do
        table.insert(vehicles, Vehicle(WORLD['width'] / 2, WORLD['height'] / 2))
    end

    seer       = Vehicle(100, 100)
    seer.color = {255,0,0,255}
end

function love.update(dt)
    local wander      = Steering:wander(seer)
    local peripherial = Steering:peripherial(seer, vehicles)

    seer:applyForce(wander)
    seer:update(dt)

    for _, vehicle in pairs(vehicles) do
        wander  = Steering:wander(vehicle)

        vehicle.color = {0,0,0,255}
        vehicle:applyForce(wander)
        vehicle:update(dt)
    end

    for _, vehicle in pairs(peripherial) do
        vehicle.color = {0,255,0,255}
    end
end

function love.draw()
    local x, y      = seer:center()
    local sight     = seer.sight
    local angle     = seer.angle
    local periphery = seer.periphery

    love.graphics.setColor(187,208,1,50)
    love.graphics.arc('fill', x, y, sight, angle - periphery, angle + periphery)

    for _, vehicle in pairs(vehicles) do
        vehicle:draw()
    end

    seer:draw()
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end
