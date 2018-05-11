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
	width    = love.graphics.getWidth(),
	height   = love.graphics.getHeight(),
	cellSize = 30
}

GAME = {
	debug = false
}

love.mouse.setVisible(false)
love.graphics.setBackgroundColor(255,255,255,255)

local Grid, Cell, vehicle
local noise = love.math.noise

function love.load()
	grid    = Grid()
	vehicle = Vehicle(WORLD['width'] / 2, WORLD['height'] / 2)
end

function love.update(dt)
	grid:update(dt)

	local flow = Steering:flow(vehicle, grid)

	vehicle:applyForce(flow)
	vehicle:update(dt)
end

function love.draw()
	grid:draw()
	vehicle:draw()
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
end

function Grid()
	local self = {
		cells = {},
		rows  = math.floor(WORLD['height'] / WORLD['cellSize']),
		cols  = math.floor(WORLD['width'] / WORLD['cellSize'])
	}

	function self:new()
		local theta, flow
		local xOff, yOff = 0, 0
		local delta      = 0.1

		for r = 1, self.rows do
			yOff = 0

			for c = 1, self.cols do
				theta = UMath:map(noise(xOff, yOff), 0, 1, 0, math.pi / 2)
				flow  = Vec2(math.cos(theta), math.sin(theta))

				table.insert(self.cells, Cell(self, r, c, flow))

				yOff  = yOff + delta
			end

			xOff = xOff + delta
		end

		return self
	end

	function self:getIndex(row, col)
	    return ((col - 1) + (row - 1) * self.cols) + 1
	end

	function self:getCell(row, col)
		local index = self:getIndex(row, col)

		return self.cells[index]
	end

	function self:getCellByLocation(x, y)
	    local row = math.ceil(y / WORLD['cellSize'])
	    local col = math.ceil(x / WORLD['cellSize'])

	    return self:getCell(row, col)
	end

	function self:lookup(entity)
		local cell = self:getCellByLocation(entity:center())

		if cell then
			return cell.flow:copy()
		end

		return entity.vel:copy()
	end

	function self:update(dt)
		for _, cell in pairs(self.cells) do
			cell:update(dt)
		end
	end

	function self:draw()
		for _, cell in pairs(self.cells) do
			cell:draw()
		end
	end

	return self:new()
end

function Cell(grid, row, col, flow)
	local self = {
		grid = grid,
		row  = row,
		col  = col,
		flow = flow
	}

	function self:index()
    	return ((self.col - 1) + (self.row - 1) * self.grid.cols) + 1
	end

	function self:position()
		local x = ((self.col - 1) * WORLD['cellSize'])
	    local y = ((self.row - 1) * WORLD['cellSize'])

	    return x, y
	end

	function self:update(dt)
		--
	end

	function self:draw()
		local x, y = self:position()

		love.graphics.setColor(100,100,100,100)
		love.graphics.rectangle('line', x, y, WORLD['cellSize'], WORLD['cellSize'])

		if self.flow then
			love.graphics.push()
			love.graphics.translate(x + WORLD['cellSize'] / 2, y + WORLD['cellSize'] / 2)
			love.graphics.rotate(self.flow:heading())

			love.graphics.setColor(100,100,100,200)
			love.graphics.line(-10, 0, 10, 0)

			love.graphics.pop()
		end
	end

	return self
end
