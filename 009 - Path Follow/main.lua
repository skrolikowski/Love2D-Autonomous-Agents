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
Path     = require 'tools.containers.path'
Vehicle  = require 'entities.vehicle'

-- Game constants
WORLD = {
	width  = love.graphics.getWidth(),
	height = love.graphics.getHeight()
}

GAME = {
	debug = true
}

love.graphics.setBackgroundColor(1,1,1,1)

local vehicles = {}
local random   = love.math.random
local limit    = 10
local path, vehicle

function love.load()
	path = Path(50, {
		Vec2(75,  75 ),
		Vec2(500, 150),
		Vec2(700, 400),
		Vec2(525, 450),
		Vec2(600, 600),
		Vec2(100, 500),
		Vec2(75,  75 ),
	})

	for i = 1, limit do
		vehicle          = Vehicle(random(0, WORLD['width']), random(0, WORLD['height']))
		vehicle.maxSpeed = random(2, 5)
		vehicle.color    = UColor:lerp(
			UMath:map(vehicle.maxSpeed, 2, 5, 0, 1),
			UColor:hexToRgb('#69B3DA'),
			UColor:hexToRgb('#E50600')
		)

		table.insert(vehicles, vehicle)
	end
end

function love.update(dt)
	for _, vehicle in pairs(vehicles) do
		vehicle.steer:follow(path)
		vehicle.steer:separate(vehicles, 25)
		vehicle.steer:queue(vehicles)

		vehicle.pos   = vehicle:nextPosition(dt)
	    vehicle.angle = vehicle.vel:heading()
	end
end

function love.draw()
	path:draw()

	for _, vehicle in pairs(vehicles) do
		vehicle:draw()
	end
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
end