--=======================================
-- filename:    entities/entity.lua
-- author:      Shane Krolikowski
-- created:     Feb, 2018
-- description: Entity super class.
--=======================================

local Object = require 'tools.class'
local Entity = Object:extend()

function Entity:new()
    --
end

-- ===================================
-- Get center coordinates of entity.
-- -------------
-- @return float (2x)
-- ===================================
function Entity:center()
    return self.pos:unpack()
end

-- ===================================
-- Determine if entity is within
--   bounds of the world.
-- -------------
-- @return boolean
-- ===================================
function Entity:inBounds()
    local x, y, w, h = self:AABB()

    return x > 0 and
           x + w < WORLD['width'] and
           y > 0 and
           y + h < WORLD['height']
end

-- ===================================
-- If entity leaves world bounds then
--  wrap position.
-- -------------
-- @return void
-- ===================================
function Entity:wrap()
    local cx, cy     = self:center()
    local x, y, w, h = self:AABB()
    local padding    = 1

    -- left wrap
    if cx + w/2 < 0 then
        self.pos.x = WORLD['width'] + w/2 - padding
    end

    -- right wrap
    if cx - w/2 > WORLD['width'] then
        self.pos.x = -w/2 + padding
    end

    -- top wrap
    if cy + h/2 < 0 then
        self.pos.y = WORLD['height'] + h/2 - padding
    end

    -- bottom wrap
    if cy - h/2 > WORLD['height'] then
        self.pos.y = -h/2 + padding
    end
end

-- ===================================
-- If entity reaches world bounds then
--  reverse it's velocity.
-- -------------
-- @return void
-- ===================================
function Entity:keepInBounds()
    --
end

-- ===================================
-- Get entity bounds (un-transformed).
-- -------------
-- @return floats
-- ===================================
function Entity:container()
    local cx, cy = self:center()
    local w      = self.width
    local h      = self.height
    local x      = cx - w / 2
    local y      = cy - h / 2

    return x, y, w, h
end

-- ===================================
-- Axis-aligned bounding box.
-- -------------
-- @return float (4x)
-- ===================================
function Entity:AABB()
    local cx, cy         = self:center()
    local angle          = self.angle or 0
    local x1, y1, x2, y2 = UMath:computeAABB(cx, cy, self.width, self.height, angle)
    local w              = x2 - x1
    local h              = y2 - y1

    return x1, y1, w, h
end

-- ===================================
-- Get entity's current cell.
-- -------------
-- @return Cell
-- ===================================
function Entity:currentCell(grid)
    return grid:getCellByLocation(self:center())
end

-- ===================================
-- Predict entity's next cell.
-- -------------
-- @return Cell
-- ===================================
function Entity:nextCell(grid)
    local cell   = self:currentCell()
    local dx, dy = self.vel:copy():normalize():unpack()
    local row    = cell.row + dy
    local col    = cell.col + dx

    return grid:getCell(row, col)
end

-- ===================================
-- Calculate entity's next position
--  based on acceleration forces.
-- -------------
-- @return Vec2
-- ===================================
function Entity:nextPosition()
    -- outside forces
    self:applyDrag()

    -- apply steering forces
    self.steer:update(dt)

    -- apply accel forces
    self.vel:add(self.acc)
    self.acc:scale(0)

    -- adjust for `maxSpeed`
    self.vel:limit(self.maxSpeed)

    return self.pos:copy():add(self.vel)
end

-- ===================================
-- Apply drag force to acceleration.
-- -------------
-- @return void
-- ===================================
function Entity:applyDrag()
    local drag = self.vel:copy()
          drag:normalize()
          drag:scale(self.drag * self.vel:magnitudeSq())

    self:applyForce(drag)
end

-- ===================================
-- Apply force acceleration.
-- -------------
-- @param Vec2 - force
-- -------------
-- @return void
-- ===================================
function Entity:applyForce(force)
    force:scale(1 / self.mass)

    self.acc:add(force)
end

-- ===================================
-- Apply force acceleration with angle
--  and magnitude.
-- -------------
-- @param float - angle
-- @param float - magnitude
-- -------------
-- @return void
-- ===================================
function Entity:applyAngleMagnitude(angle, magnitude)
    local force = Vec2(0, 0)

    force:setAngle(angle)
    force:setMagnitude(magnitude)
    force:scale(1 / self.mass)

    self.acc:add(force)
end

-- ===================================
-- Entity has collided with another.
-- -------------
-- @param entity - other entity
-- -------------
-- @return void
-- ===================================
function Entity:collidedWith(entity)
    print('collision!')
end

-- ===================================
-- Entity has been destroyed.
-- -------------
-- @param entity = destroyer
-- -------------
-- @return void
-- ===================================
function Entity:destroy(entity)
    if entity == nil then
        -- Entity reached it's destination!
    end

    self.remove = true
end

return Entity