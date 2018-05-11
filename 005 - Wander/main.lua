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

love.mouse.setVisible(false)
love.graphics.setBackgroundColor(255,255,255,255)

local vehicle

function love.load()
    vehicle = Vehicle(WORLD['width'] / 2, WORLD['height'] / 2)
end

function love.update(dt)
    local wander = Steering:wander(vehicle)

    vehicle:applyForce(wander)
    vehicle:update(dt)
end

function love.draw()
    vehicle:draw()
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end
