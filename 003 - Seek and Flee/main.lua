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

local vehicle, cursor, fleeZone

function love.load()
    cursor   = Vec2(love.mouse.getPosition())
    vehicle  = Vehicle(cursor.x, cursor.y)
    fleeZone = Vec2(WORLD['width'] / 2, WORLD['height'] / 2)
end

function love.update(dt)
    local seek = Steering:seek(vehicle, cursor)
    local flee = Vec2()

    if vehicle.pos:distance(fleeZone) <= 100 then
        flee = Steering:flee(vehicle, fleeZone)
        flee:scale(2)
    end

    vehicle:applyForce(seek)
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

    love.graphics.setColor(255, 0, 0, 100)
    love.graphics.circle('fill', fleeZone.x, fleeZone.y, 100)
    love.graphics.setColor(255, 0, 0, 255)
    love.graphics.circle('line', fleeZone.x, fleeZone.y, 100)
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
