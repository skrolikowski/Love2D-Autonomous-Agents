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
    debug = true
}

love.graphics.setBackgroundColor(255,255,255,255)

local pursurer, evader

function love.load()
    pursurer = Vehicle(100, 100)
    pursurer.color = {0,255,0,255}
    pursurer.maxSpeed = 2
    evader = Vehicle(500, 500)
    evader.color = {255,0,0,255}
    evader.maxSpeed = 3
end

function love.update(dt)
    local pursuit = Steering:pursuit(pursurer, evader)
    local evade   = Steering:evade(evader, pursurer, 100)

    pursurer:applyForce(pursuit)
    evader:applyForce(evade)

    pursurer:update(dt)
    evader:update(dt)
end

function love.draw()
    pursurer:draw()
    evader:draw()
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end
