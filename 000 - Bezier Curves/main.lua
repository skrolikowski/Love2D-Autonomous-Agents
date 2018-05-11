--=======================================
-- filename:    main.lua
-- author:      Shane Krolikowski
-- created:     May, 2018
-- description: Bootstrapper.
--=======================================

-- Game libraries
PP = require 'libs.pprint.pprint'

-- Game tools
Vec2     = require 'tools.vec2'
UMath    = require 'tools.utils.math'
UColor   = require 'tools.utils.color'

WORLD = {
    width  = love.graphics.getWidth(),
    height = love.graphics.getHeight()
}

GAME = {
    debug = true
}

love.mouse.setVisible(false)
love.graphics.setBackgroundColor(1,1,1,1)

function love.load()
    points = {}

    for i = 1, 3 do
        table.insert(points, UMath:randomInt(25, WORLD['width'] - 25))
        table.insert(points, UMath:randomInt(25, WORLD['height'] - 25))
    end

    curve = love.math.newBezierCurve(points)
end

function love.update(dt)
    --
end

function love.draw()
    local vertices = curve:render(5)

    love.graphics.setColor(0,0,0,1)
    love.graphics.line(vertices)

    for i = 1, #vertices, 2 do
        love.graphics.setColor(0,0,1,1)
        love.graphics.circle('line', vertices[i], vertices[i+1], 5)
    end

    for i = 1, #points, 2 do
        love.graphics.setColor(1,0,0,1)
        love.graphics.circle('line', points[i], points[i+1], 5)
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end
