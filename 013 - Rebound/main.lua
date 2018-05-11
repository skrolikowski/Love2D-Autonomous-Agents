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

function love.load()
    vehicle = Vehicle(WORLD['width'] / 2, WORLD['height'] / 2)
end

function love.update(dt)
    local wander  = Steering:wander(vehicle)
    local rebound = Steering:rebound(vehicle, 50)

    wander:scale(1)
    rebound:scale(2)

    vehicle:applyForce(wander)
    vehicle:applyForce(rebound)
    vehicle:update(dt)
end

function love.draw()
    vehicle:draw()

    love.graphics.setColor(200,200,200,255)
    love.graphics.rectangle('line', 25, 25, 250, 250)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end
