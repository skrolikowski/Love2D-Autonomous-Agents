--=======================================
-- filename:    entities/spawner.lua
-- author:      Shane Krolikowski
-- created:     Mar, 2018
-- description: Vehicle spawner.
--=======================================

local Object  = require 'tools.class'
local Spawner = Object:extend()

local mouseDown = false

function Spawner:new()
    self.entities = {}
end

function Spawner:add(x, y)
    table.insert(self.entities, Vehicle(x, y))
end

function Spawner:tick()
	if mouseDown then
		self:add(love.mouse.getPosition())
	end
end

function Spawner:update(dt)
    -- remove
    for i = #self.entities, 1, -1 do
        if self.entities[i].remove then
            table.remove(self.entities, i)
        end
    end

    -- update
    for _, entity in pairs(self.entities) do
        entity:update(dt)
    end

    -- spawn new vehicle
    if love.mouse.isDown(1) then
    	mouseDown = true
    else
    	mouseDown = false
    end
end

function Spawner:draw()
    for _, entity in pairs(self.entities) do
        entity:draw()
    end
end

return Spawner
