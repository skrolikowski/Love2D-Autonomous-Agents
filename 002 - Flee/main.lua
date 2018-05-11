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

love.mouse.setVisible(false)
love.graphics.setBackgroundColor(255,255,255,255)

local vehicle, cursor

function love.load()
    cursor  = Vec2(love.mouse.getPosition())
    vehicle = Vehicle(cursor.x, cursor.y)
end

function love.update(dt)
    local wander = Steering:wander(vehicle, 100)
    local flee   = Steering:flee(vehicle, cursor, 250)

    vehicle:applyForce(wander)
    vehicle:applyForce(flee)
    vehicle:update(dt)

    cursor = Vec2(love.mouse:getPosition())
end

function love.draw()
    vehicle:draw()

    love.graphics.setColor(100,100,100,100)
    love.graphics.circle('fill', cursor.x, cursor.y, 25)

    love.graphics.setColor(0,0,0,255)
    love.graphics.circle('line', cursor.x, cursor.y, 25)
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
