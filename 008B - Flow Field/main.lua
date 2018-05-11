--=======================================
-- filename:    main.lua
-- author:      Shane Krolikowski
-- created:     Mar, 2018
-- description: Bootstrapper.
--=======================================

-- Game tools
Vec2      = require 'tools.vec2'
UMath     = require 'tools.utils.math'
SManager  = require 'tools.utils.steermanager'
FlowField = require 'tools.containers.flowfield'
Grid      = require 'tools.containers.grid'
Cell      = require 'tools.containers.cell'

-- Game entities
Vehicle  = require 'entities.vehicle'

WORLD = {
    width    = love.graphics.getWidth(),
    height   = love.graphics.getHeight(),
    cellSize = 30
}

GRID = {
    xOffset = 0,
    yOffset = 0,
    cols = 10,
    rows = 10,
    cell = {
        size    = 60,
        padding = 0
    }
}

GAME = {
    debug = false
}

love.graphics.setBackgroundColor(255,255,255,255)

function love.load()
    grid    = Grid(GRID['rows'], GRID['cols'])
    vehicle = Vehicle(WORLD['width'] / 2, WORLD['height'] / 2)
end

function love.update(dt)
    if flowField then
        vehicle.steer:flow(flowField)
    end

    vehicle.pos   = vehicle:nextPosition(dt)
    vehicle.angle = vehicle.vel:heading()

    vehicle:wrap()
end

function love.draw()
    -- grid:draw()

    if flowField then
        flowField:draw()
    end

    vehicle:draw()
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        flowField = FlowField(grid, grid:getCellByLocation(x, y))
    end
end