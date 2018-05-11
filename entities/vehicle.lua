--=======================================
-- filename:    entities/vehicle.lua
-- author:      Shane Krolikowski
-- created:     Mar, 2018
-- description: Vehicle entity.
--=======================================

local Entity  = require 'entities.entity'
local Vehicle = Entity:extend()

function Vehicle:new(x, y)
    self.pos    = Vec2(x, y)
    self.vel    = Vec2(0, 0)
    self.acc    = Vec2(0, 0)

    self.width  = 25
    self.height = 15

    -- characteristics
    self.periphery = math.pi / 8
    self.sight     = 25
    self.angle     = 0
    self.mass      = 1
    self.drag      = -0.1
    self.color     = {0,0,0,1}

    -- force limits
    self.maxSpeed = 2
    self.maxForce = 1

    -- steering behaviors
    self.steer = SManager(self)
    self.path  = nil

    self.remove = false
end

function Vehicle:update(dt)
    self.steer:follow(self.path)
    self.steer:queue(vehicles)

    -- must stop at intersection?
    for _, intersection in pairs(intersections) do
        if intersection:trafficStop(self, self.path) then
            self.vel:scale(0.8)  -- reduce speed
            self.steer:reset()   -- cancel steering force
            break
        end
    end

    self.pos   = self:nextPosition(dt)
    self.angle = self.vel:heading()

    self:wrap()
end

function Vehicle:draw()
	local cx, cy     = self:center()
    local sx, sy     = self.scale, self.scale
    local x, y, w, h = self:container()

	love.graphics.push()
	love.graphics.translate(cx, cy)
	love.graphics.rotate(self.angle)

	love.graphics.setColor(self.color)
	love.graphics.rectangle('fill', -w / 2, -h / 2, w, h)

	love.graphics.pop()

    -- debug
    if GAME['debug'] then
        if self.steer then self.steer:draw() end
        if self.fsm   then self.fsm:draw()   end
        if self.path  then self.path:draw()  end

        -- axis-aligned bounding box
        love.graphics.setColor(UColor:hexToRgb('#D1263D'))
        love.graphics.rectangle('line', self:AABB())

        -- velocity vector
        love.graphics.setColor(UColor:hexToRgb('#9DD160'))
        love.graphics.setLineWidth(2)
        love.graphics.line(cx, cy, cx + self.vel.x * 10, cy + self.vel.y * 10)
    end
end

return Vehicle
