--=======================================
-- filename:    main.lua
-- author:      Shane Krolikowski
-- created:     Mar, 2018
-- description: Bootstrapper.
--=======================================

Vec2     = require 'tools.vec2'
UMath    = require 'tools.utils.math'
UColor   = require 'tools.utils.color'
SManager = require 'tools.ai.steermanager'
Vehicle  = require 'entities.vehicle'

WORLD = {
	width  = love.graphics.getWidth(),
	height = love.graphics.getHeight()
}

GAME = {
	debug = true
}

love.mouse.setVisible(false)
love.graphics.setBackgroundColor(1,1,1,1)

local vehicle, cursor

function love.load()
	cursor  = Vec2(love.mouse.getPosition())
	vehicle = Vehicle(cursor.x, cursor.y)
end

function love.update(dt)
	vehicle.steer:seek(cursor)

	vehicle.pos   = vehicle:nextPosition(dt)
    vehicle.angle = vehicle.vel:heading()

    vehicle:wrap()

	cursor = Vec2(love.mouse:getPosition())
end

function love.draw()
	vehicle:draw()

	love.graphics.setColor(0.5,0.5,0.5,0.5)
	love.graphics.circle('fill', cursor.x, cursor.y, 25)

	love.graphics.setColor(0,0,0,1)
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
